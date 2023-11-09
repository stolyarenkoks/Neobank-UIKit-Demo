//
//  CardViewController.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - CardViewController

class CardViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet private var folderButton: UIButton!
    @IBOutlet private var folderButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet private var balanceLabel: UILabel!
    @IBOutlet private var bottomSheetView: UIView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var expandButton: UIButton!
    @IBOutlet private var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var buttonsView: UIView!
    @IBOutlet private var buttonsViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var balanceLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private var refillButton: UIButton!
    @IBOutlet private var transferButton: UIButton!
    @IBOutlet private var paymentsButton: UIButton!

    // MARK: - Internal Properties

    var updateVerticalCardsPosition: ((CGFloat, Bool) -> Void)?
    var swipeInteractionController: SwipeInteractionController?
    weak var pageViewController: CardsPageViewController?

    var isBottomSheetTopOrInProgress: Bool {
        currentBottomSheetPosition != .bottom
    }

    // MARK: - Private Properties

    private var sections: [(date: Date, transactions: [Transaction])] = []

    private lazy var cardsMenuViewController: CardsMenuPageViewController? = {
        let controller = Storyboard.cardsMenu.instantiateVC(CardsMenuPageViewController.self)
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        return controller
    }()

    private lazy var balanceLabelTopPadding: CGFloat = {
        return balanceLabelTopConstraint.constant
    }()

    private var currentBottomSheetPosition: BottomSheetPosition = .bottom
    private var shouldAnimateToTop = false
    private var currentHeight: CGFloat = .zero
    private var bottomSheetMaxHeight: CGFloat = .zero
    private var bottomSheetMinHeight: CGFloat = .zero

    // MARK: - ViewController Lifecycle Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBottomSheetView()
        setupTransactions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard currentBottomSheetPosition == .bottom else { return }
        updateBottomSheetPosition(position: .current(bottomSheetMinHeight))
    }

    // MARK: - Setup

    override func setupUI() {
        let cards = MockDataManager.shared.generateCardsDataSource()
        let platinumCard = cards.first(where: { $0.cardType == .platinum })
        balanceLabel.text = platinumCard?.formattedBalance

        folderButton.layer.cornerRadius = folderButton.frame.size.width / 2
        [refillButton, transferButton, paymentsButton].forEach({ setupRoundedButton(button: $0) })
        refillButton.setTitle(Const.CardViewController.refillTitle, for: .normal)
        transferButton.setTitle(Const.CardViewController.sendTitle, for: .normal)
        paymentsButton.setTitle(Const.CardViewController.payTitle, for: .normal)

        guard let safeAreaTopInset = UIApplication.shared.windows.first?.safeAreaInsets.top else { return }
        let availableHeight = UIScreen.main.bounds.height - safeAreaTopInset
        bottomSheetMaxHeight = availableHeight - Const.CardViewController.bottomSheetMaxHeightOffset
        let cardOffset = UIScreen.main.bounds.width * Const.CardsPageViewController.cardContainerAspectRatio
        let viewsOffset = Const.CardsPageViewController.pageControlHeight + Const.CardViewController.buttonsViewHeight
        bottomSheetMinHeight = availableHeight - cardOffset - viewsOffset
        currentHeight = bottomSheetMinHeight
    }

    override func setupSettings() {
        if let animatedViewController = cardsMenuViewController {
            swipeInteractionController = SwipeInteractionController(rootViewController: self,
                                                                    animatedViewController: animatedViewController,
                                                                    isPresentInteraction: true)
        }
        tableView.isUserInteractionEnabled = false
        tableView.register(nibName: Const.BaseTableCell.cellNibName,
                           cellId: Const.BaseTableCell.cellId)
        tableView.register(nibName: Const.BaseTableHeaderView.viewNibName,
                           headerViewId: Const.BaseTableHeaderView.viewId)
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = .zero
        }
    }

    private func setupBottomSheetView() {
        bottomSheetView.layer.cornerRadius = 15

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(bottomSheetPanGesture))
        gesture.delegate = self
        bottomSheetView.addGestureRecognizer(gesture)
    }

    private func setupTransactions() {
        var transactionGroups: [Date: [Transaction]] = [:]

        for transaction in MockDataManager.shared.generateTransactionsDataSource() {
            if transactionGroups[transaction.date.removeTime()] == nil {
                transactionGroups[transaction.date.removeTime()] = [transaction]
            } else {
                transactionGroups[transaction.date.removeTime()]?.append(transaction)
            }
        }
        sections = transactionGroups.map({ (date: $0.key, transactions: $0.value) }).sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        tableView.reloadData()
    }

    // MARK: - Actions

    @IBAction private func presentButtonTapped(_ sender: Any) {
        presentCardsController()
    }

    @IBAction private func expandButtonTapped(_ sender: Any) {
        switch currentBottomSheetPosition {
        case .top:
            shouldAnimateToTop = false
            updateBottomSheetPosition(position: .bottom)
        case .bottom:
            shouldAnimateToTop = true
            updateBottomSheetPosition(position: .top)
        case .current:
            break
        }
    }

    private func presentCardsController() {
        guard let controller = cardsMenuViewController else { return }
        present(controller, animated: true, completion: nil)
    }

    // MARK: - Private Methods

    @objc private func bottomSheetPanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        switch recognizer.state {
        case .changed:
            let newMinHeight = bottomSheetMinHeight + translation.y
            let newMaxHeight = bottomSheetMaxHeight + translation.y
            let newHeight = currentHeight - translation.y
            guard currentHeight >= newMinHeight else {
                updateBottomSheetPosition(position: .bottom)
                return
            }
            guard currentHeight <= newMaxHeight else {
                updateBottomSheetPosition(position: .top)
                return
            }
            updateBottomSheetPosition(position: .current(newHeight))
            shouldAnimateToTop = shouldAnimateToTop(dependOn: newHeight)
        case .ended:
            updateBottomSheetPosition(position: shouldAnimateToTop ? .top : .bottom)
        default:
            break
        }
    }

    private func updateBottomSheetPosition(position: BottomSheetPosition) {
        var isAnimated: Bool = false
        switch position {
        case .top:
            bottomViewHeightConstraint.constant = bottomSheetMaxHeight
            currentBottomSheetPosition = .top
            currentHeight = bottomViewHeightConstraint.constant
            isAnimated = true
            pageViewController?.isEnableScrolling = false
            tableView.isUserInteractionEnabled = true
            UIView.animate(withDuration: AnimationTime.slow.rawValue) {
                self.expandButton.transform = CGAffineTransform(rotationAngle: .pi)
            }
        case .bottom:
            bottomViewHeightConstraint.constant = bottomSheetMinHeight
            currentBottomSheetPosition = .bottom
            currentHeight = bottomViewHeightConstraint.constant
            isAnimated = true
            pageViewController?.isEnableScrolling = true
            tableView.isUserInteractionEnabled = false
            tableView.scrollToRow(at: IndexPath(row: .zero, section: .zero), at: .top, animated: true)
            UIView.setAnimationsEnabled(true)
            UIView.animate(withDuration: AnimationTime.slow.rawValue) {
                self.expandButton.transform = CGAffineTransform(rotationAngle: .pi * -2)
            }
        case .current(let currentHeight):
            bottomViewHeightConstraint.constant = currentHeight
        }
        updateDependentViews(dependOn: bottomViewHeightConstraint.constant, animated: isAnimated)
    }

    private func setupRoundedButton(button: UIButton) {
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightCulturedWhiteColor.cgColor
        button.setTitleColor(UIColor.lightCulturedWhiteColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
    }

    private func updateDependentViews(dependOn newHeight: CGFloat, animated: Bool) {
        let basePercent = calculateScrollPercent(dependOn: newHeight)
        updateTopView(with: basePercent)
        updateBalanceView(with: basePercent)
        updateButtonsView(with: basePercent)
        updateCardViews(with: basePercent, animated: animated)
    }

    private func updateTopView(with percent: CGFloat) {
        let weightedPercent = -(percent)
        let extraSpace = balanceLabelTopPadding * percent / 100
        folderButtonTopConstraint.constant = weightedPercent - extraSpace
        balanceLabelTopConstraint.constant = balanceLabelTopPadding + extraSpace
    }

    private func updateButtonsView(with percent: CGFloat) {
        let weightedPercent = percent * 2.5
        buttonsView.alpha = getAlpha(with: weightedPercent)
        buttonsViewBottomConstraint.constant = -weightedPercent
    }

    private func updateBalanceView(with percent: CGFloat) {
        balanceLabel.alpha = getAlpha(with: percent)
    }

    private func getAlpha(with percent: CGFloat) -> CGFloat {
        return 1 - (percent / 100)
    }

    private func updateCardViews(with percent: CGFloat, animated: Bool) {
        let weightedPercent = percent * 4
        updateVerticalCardsPosition?(weightedPercent, animated)
    }

    private func calculateScrollPercent(dependOn newHeight: CGFloat, topInset: CGFloat = .zero) -> CGFloat {
        let maxValue = bottomSheetMaxHeight - topInset
        let minValue = bottomSheetMinHeight
        let currentValue = newHeight

        var currentPercent: CGFloat = 1.0
        let diff = maxValue - minValue
        let wightedNewHeight = currentValue - minValue
        currentPercent = (wightedNewHeight * 100) / diff
        return currentPercent
    }

    private func shouldAnimateToTop(dependOn newHeight: CGFloat) -> Bool {
        let percent: CGFloat = 20.0
        let diff: CGFloat = bottomSheetMaxHeight - bottomSheetMinHeight
        let offset: CGFloat = diff / (100 / percent)
        var saddlePoint: CGFloat = .zero
        if currentBottomSheetPosition == .bottom {
            saddlePoint = bottomSheetMinHeight + offset
        } else {
            saddlePoint = bottomSheetMaxHeight - offset
        }
        return newHeight > saddlePoint
    }
}

// MARK: - UIViewControllerTransitioningDelegate Extension

extension CardViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentCardsMenuTransition(fromViewFrame: folderButton.frame,
                                          interactionController: swipeInteractionController)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let revealVC = dismissed as? CardsMenuPageViewController else { return nil }
        return DismissCardsMenuTransition(interactionController: revealVC.swipeInteractionController)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? DismissCardsMenuTransition,
              let interactionController = animator.interactionController,
              interactionController.interactionInProgress else { return nil }
        return interactionController
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? PresentCardsMenuTransition,
              let interactionController = animator.interactionController,
              interactionController.interactionInProgress else { return nil }
        return interactionController
    }
}

// MARK: - UITableViewDataSource Extension

extension CardViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].transactions.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let baseTableCell = tableView.dequeueReusableCell(withIdentifier: Const.BaseTableCell.cellId,
                                                                for: indexPath) as? BaseTableCell else {
            return UITableViewCell()
        }
        let transactionModel = sections[indexPath.section].transactions[indexPath.row]
        baseTableCell.setupCell(with: transactionModel)
        return baseTableCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Const.BaseTableHeaderView.viewId)
        guard let baseHeaderView = headerView as? BaseTableHeaderView else { return nil }
        baseHeaderView.setupView(with: sections[section].date)
        return baseHeaderView
    }
}

// MARK: - UITableViewDelegate Extension

extension CardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.BaseTableCell.cellHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Const.BaseTableHeaderView.viewHeight
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.setAnimationsEnabled(false)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.setAnimationsEnabled(true)
    }
}

// MARK: - UIGestureRecognizerDelegate Extension

extension CardViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view == tableView,
           currentBottomSheetPosition == .top {
            return tableView.contentOffset.y <= .zero
        }
        return false
    }
}
