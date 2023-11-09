//
//  CardDetailViewController.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - BottomSheetPosition enum

enum BottomSheetPosition: Equatable {
    case top
    case bottom
    case current(CGFloat)
}

// MARK: - CardDetailViewController

class CardDetailViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet private var cardsContainerView: UIView!
    @IBOutlet private var cardsContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet private var limitContainer: UIView!
    @IBOutlet private var limitCardLabel: UILabel!
    @IBOutlet private var limitCardDescriptionLabel: UILabel!
    @IBOutlet private var limitProgressContainer: UIView!
    @IBOutlet private var limitProgressView: UIView!
    @IBOutlet private var bottomSheetView: UIView!
    @IBOutlet private var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var expandButton: UIButton!
    @IBOutlet private var buttonsView: UIView!
    @IBOutlet private var buttonsViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Internal Properties

    var updateVerticalCardsPosition: ((CGFloat, Bool) -> Void)?
    var cardsViewTapped: ((UIView.AnimationOptions) -> Void)?
    weak var pageViewController: CardsPageViewController?

    // MARK: - Private Properties

    private var cardDetails: [CardDetailViewModel] = []
    private var currentPosition: BottomSheetPosition = .bottom
    private var shouldAnimateToTop = false
    private var currentHeight: CGFloat = .zero
    private var bottomSheetMaxHeight: CGFloat = .zero
    private var bottomSheetMinHeight: CGFloat = .zero

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBottomSheetView()
        setupCardsView()
        setupCardSettings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard currentPosition == .bottom else { return }
        updateBottomSheetPosition(position: .current(bottomSheetMinHeight))
    }

    // MARK: - Setup

    override func setupUI() {
        setupRoundedView(view: limitContainer)
        [limitProgressContainer, limitProgressView].forEach({ makeRoundedCorners(view: $0) })
        limitCardLabel.textColor = .whiteColor
        limitCardDescriptionLabel.textColor = .ghostWhiteColor.withAlphaComponent(0.6)

        limitProgressView.backgroundColor = UIColor.mediumAquamarine
        guard let safeAreaTopInset = UIApplication.shared.windows.first?.safeAreaInsets.top else { return }
        let availableHeight = UIScreen.main.bounds.height - safeAreaTopInset
        bottomSheetMaxHeight = availableHeight - Const.CardDetailViewController.bottomSheetMaxHeightOffset
        let cardOffset = UIScreen.main.bounds.width * Const.CardsPageViewController.cardContainerAspectRatio
        let viewsOffset = Const.CardsPageViewController.pageControlHeight + Const.CardDetailViewController.buttonsViewHeight
        bottomSheetMinHeight = availableHeight - cardOffset - viewsOffset
        currentHeight = bottomSheetMinHeight
    }

    override func setupSettings() {
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
        bottomSheetView.addGestureRecognizer(gesture)
    }

    private func setupCardsView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardsViewDidTapped(_:)))
        cardsContainerView.addGestureRecognizer(tapGesture)
    }

    private func setupRoundedView(view: UIView) {
        view.layer.cornerRadius = view.bounds.height / 2
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightCulturedWhiteColor.cgColor
    }

    private func setupCardSettings() {
        cardDetails = [
            CardDetailViewModel(title: Const.CardDetailViewController.blockCardTitle,
                                subtitle: Const.CardDetailViewController.blockCardSubtitle,
                                image: UIImage(systemName: "xmark.circle")!),
            CardDetailViewModel(title: Const.CardDetailViewController.onlinePaymentsTitle,
                                subtitle: Const.CardDetailViewController.onlinePaymentsSubtitle,
                                image: UIImage(systemName: "at.circle")!),
            CardDetailViewModel(title: Const.CardDetailViewController.pinCodeTitle,
                                image: UIImage(systemName: "lock.circle")!),
            CardDetailViewModel(title: Const.CardDetailViewController.creditLimitTitle,
                                subtitle: Const.CardDetailViewController.creditLimitSubtitle,
                                image: UIImage(systemName: "dollarsign.arrow.circlepath")!),
            CardDetailViewModel(title: Const.CardDetailViewController.applePayTitle,
                                subtitle: Const.CardDetailViewController.applePaySubtitle,
                                image: UIImage.CardDetailViewModel.applePayImage)
        ]
        tableView.reloadData()
    }

    // MARK: - Actions

    @IBAction private func expandButtonTapped(_ sender: Any) {
        switch currentPosition {
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

    // MARK: - Private Methods

    @objc private func cardsViewDidTapped(_ gestureRecognizer: UIGestureRecognizer) {
        let tappedPoint = gestureRecognizer.location(in: cardsContainerView)

        let leftArea = CGRect(x: cardsContainerView.frame.origin.x,
                              y: cardsContainerView.frame.origin.y,
                              width: cardsContainerView.frame.size.width / 2,
                              height: cardsContainerView.frame.size.height)

        let rightArea = CGRect(x: cardsContainerView.frame.origin.x + cardsContainerView.frame.size.width / 2,
                               y: cardsContainerView.frame.origin.y,
                               width: cardsContainerView.frame.size.width / 2,
                               height: cardsContainerView.frame.size.height)

        if leftArea.contains(tappedPoint) {
            cardsViewTapped?(.transitionFlipFromRight)
        } else if rightArea.contains(tappedPoint) {
            cardsViewTapped?(.transitionFlipFromLeft)
        } else {
            debugPrint("undefined")
        }
    }

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
            currentPosition = .top
            currentHeight = bottomViewHeightConstraint.constant
            isAnimated = true
            pageViewController?.isEnableScrolling = false
            tableView.isUserInteractionEnabled = true
            UIView.animate(withDuration: AnimationTime.slow.rawValue) {
                self.expandButton.transform = CGAffineTransform(rotationAngle: .pi)
            }
        case .bottom:
            bottomViewHeightConstraint.constant = bottomSheetMinHeight
            currentPosition = .bottom
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

    private func updateDependentViews(dependOn newHeight: CGFloat, animated: Bool) {
        let basePercent = calculateScrollPercent(dependOn: newHeight)
        updateButtonsView(with: basePercent)
        updateCardViews(with: basePercent, animated: animated)
    }

    private func updateButtonsView(with percent: CGFloat) {
        let weightedPercent = percent * 2.6
        buttonsView.alpha = getAlpha(with: weightedPercent)

        buttonsViewBottomConstraint.constant = -weightedPercent
    }

    private func updateCardViews(with percent: CGFloat, animated: Bool) {
        let weightedPercent = percent * 4
        updateVerticalCardsPosition?(weightedPercent, animated)

        cardsContainerTopConstraint.constant = -weightedPercent
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
        let percent: CGFloat = 30.0
        let diff: CGFloat = bottomSheetMaxHeight - bottomSheetMinHeight
        let offset: CGFloat = diff / (100 / percent)
        var saddlePoint: CGFloat = .zero
        if currentPosition == .bottom {
            saddlePoint = bottomSheetMinHeight + offset
        } else {
            saddlePoint = bottomSheetMaxHeight - offset
        }
        return newHeight > saddlePoint
    }

    private func makeRoundedCorners(view: UIView) {
        view.layer.cornerRadius = min(view.frame.width, view.frame.height) / 2
    }

    private func getAlpha(with percent: CGFloat) -> CGFloat {
        return 1 - (percent / 100)
    }
}

// MARK: - UITableViewDataSource Extension

extension CardDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardDetails.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let baseTableCell = tableView.dequeueReusableCell(withIdentifier: Const.BaseTableCell.cellId,
                                                                for: indexPath) as? BaseTableCell else {
            return UITableViewCell()
        }
        let cardDetail = cardDetails[indexPath.row]
        baseTableCell.setupCell(with: cardDetail)
        return baseTableCell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Const.BaseTableHeaderView.viewId)
        guard let baseHeaderView = headerView as? BaseTableHeaderView else { return nil }
        baseHeaderView.setupView(with: "Mastercard Settings")
        return baseHeaderView
    }
}

// MARK: - UITableViewDelegate Extension

extension CardDetailViewController: UITableViewDelegate {

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
