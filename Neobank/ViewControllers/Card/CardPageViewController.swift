//
//  CardsPageViewController.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - CardsPageViewController

class CardsPageViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet private var pageControl: UIPageControl!
    @IBOutlet private var cardsViewContainer: UIView!
    @IBOutlet private var cardsImageViewContainer: UIView!
    @IBOutlet private var cardsViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var cardsViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet private var cardsViewRightConstraint: NSLayoutConstraint!

    // MARK: - Internal Properties

    var isEnableScrolling: Bool = false {
        didSet {
            scrollView.isScrollEnabled = isEnableScrolling
        }
    }

    var isDragInProgress: Bool {
        scrollView.isDragging
    }

    var cardsViewContainerHeight: CGFloat {
        cardsViewContainer.frame.height
    }

    // MARK: - Private Properties

    private var pageController: UIPageViewController!
    private var scrollView: UIScrollView!
    private var viewControllers: [UIViewController] = []
    private var currentPageIndex: Int = .zero {
        didSet {
            pageControl.currentPage = currentPageIndex
        }
    }
    private var startOffset: CGFloat = .zero
    private var tabBarFrame: CGRect?

    private lazy var awardsViewController: AwardsViewController! = {
        let controller = Storyboard.card.instantiateVC(AwardsViewController.self)
        controller.pageViewController = self
        controller.updatePageControl = { [weak self] isVisible in
            self?.updatePageControl(isVisible: isVisible)
        }
        return controller
    }()

    private lazy var cardViewController: CardViewController! = {
        let controller = Storyboard.card.instantiateVC(CardViewController.self)
        controller.pageViewController = self
        controller.updateVerticalCardsPosition = { [weak self] percent, animated in
            self?.updateVerticalCardsPosition(percent, animated: animated)
        }
        return controller
    }()

    private lazy var cardDetailViewController: CardDetailViewController! = {
        let controller = Storyboard.card.instantiateVC(CardDetailViewController.self)
        controller.pageViewController = self
        controller.updateVerticalCardsPosition = { [weak self] percent, animated in
            self?.updateVerticalCardsPosition(percent, animated: animated)
        }
        controller.cardsViewTapped = { [weak self] option in
            self?.flipCardsView(option: option)
        }
        return controller
    }()

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.locations = [0, 1]
        return gradientLayer
    }()

    private var cardFrontView: CardFrontView!
    private var cardBackView: CardBackView!

    private var isCardBackImageVisible = false
    private var isCardAnimationInProgress = false

    // MARK: - ViewController Lifecycle Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
        setupGradient()
        setupCardsView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updatePageControllerFrame()
        updateTabBarFrame()
        updateCardsViewFrame()
        updateCardShadow()
        updateScrollPosition(.zero)
    }

    // MARK: - Setup

    private func setupPageViewController() {
        viewControllers = [
            awardsViewController,
            cardViewController,
            cardDetailViewController
        ]

        currentPageIndex = 1

        pageController = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: nil)
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self

        let scrollViews = pageController.view.subviews as? [UIScrollView] ?? []
        for scrollView in scrollViews {
            self.scrollView = scrollView
            self.scrollView.delegate = self
        }

        isEnableScrolling = true

        pageController.setViewControllers([viewControllers[currentPageIndex]],
                                          direction: .forward,
                                          animated: false,
                                          completion: nil)
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)

        updatePageControllerFrame()
    }

    private func setupGradient() {
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: .zero)
        updateGradient(animated: false)
    }

    private func setupCardsView() {
        cardBackView = CardBackView.instantiate()
        cardsImageViewContainer.addSubview(cardBackView)
        cardBackView.adjustFrame(inView: cardsImageViewContainer)
        cardBackView.isHidden = !isCardBackImageVisible

        cardFrontView = CardFrontView.instantiate()
        cardsImageViewContainer.addSubview(cardFrontView)
        cardFrontView.adjustFrame(inView: cardsImageViewContainer)

        updateCardShadow()
    }

    // MARK: - Private Methods

    private func updatePageControllerFrame() {
        pageController.view.frame = CGRect(x: 0,
                                           y: 0,
                                           width: UIScreen.main.bounds.width,
                                           height: UIScreen.main.bounds.height)
    }

    private func index(of viewController: UIViewController) -> Int {
        if viewControllers.contains(viewController) {
            return viewControllers.firstIndex(of: viewController)!
        }
        return -1
    }

    private func updateTabBarFrame() {
        tabBarFrame = tabBarController?.tabBar.frame
    }

    private func updateScrollPosition(_ percent: CGFloat) {
        updateTabBarPosition(percent)
        updateHorizontalCardsPosition(percent)
    }

    private func scrollPositionUpdated(pageIndex: Int) {
        currentPageIndex = pageIndex
        flipToFrontOnFirstPage()
    }

    private func flipToFrontOnFirstPage() {
        if currentPageIndex == 1, isCardBackImageVisible {
            flipCardsView(option: .transitionFlipFromRight)
        }
    }

    private func updateTabBarPosition(_ percent: CGFloat) {
        // Prevent updating tabBar position for not related pages
        guard currentPageIndex <= 1 else { return }
        if currentPageIndex == 1 && percent > .zero { return }

        // Prevent updating tabBar position if tabBar is not exists
        guard let tabBarController = tabBarController,
              let tabBarFrame = tabBarFrame else { return }

        let tabBarHeight = tabBarFrame.size.height

        let yOffset = percent * tabBarHeight
        let yPosition = tabBarFrame.origin.y - yOffset

        // Prevent transition for zero offset
        if yOffset == .zero {
            // Update tabBar frame when transition ended
            self.tabBarFrame = tabBarController.tabBar.frame
            return
        }

        tabBarController.setTabBarPosition(yPosition: yPosition)
    }

    private func updateHorizontalCardsPosition(_ percent: CGFloat) {
        let visiblePercent: CGFloat = 82.0
        let horizontalOffset: CGFloat = UIScreen.main.bounds.width * visiblePercent / 100
        var currentPosition: CGFloat = .zero

        switch currentPageIndex {
        case 0:
            currentPosition = horizontalOffset * 2 - (horizontalOffset * percent)
        case 1:
            if percent > .zero {
                currentPosition = horizontalOffset - (horizontalOffset * percent)
            } else {
                currentPosition = horizontalOffset - (horizontalOffset * percent)
            }
        case 2:
            currentPosition = -(horizontalOffset * percent)
        default:
            break
        }

        guard currentPosition != -.zero else { return }
        guard let cardsViewLeftConstraint = cardsViewLeftConstraint,
              let cardsViewRightConstraint = cardsViewRightConstraint else { return }
        cardsViewLeftConstraint.constant = currentPosition
        cardsViewRightConstraint.constant = currentPosition
    }

    private func updateVerticalCardsPosition(_ percent: CGFloat, animated: Bool) {
        guard let cardsViewTopConstraint = cardsViewTopConstraint else { return }
        cardsViewTopConstraint.constant = -percent
        guard animated else { return }
        UIView.animate(withDuration: AnimationTime.veryFast.rawValue) {
            self.view.layoutIfNeeded()
        }
    }

    private func getGradientColors(for pageIndex: Int) -> [GradientViewModel] {
        switch pageIndex {
        case 0:
            return [
                .init(color: .grDarkBlackColor, position: CGPoint(x: .zero, y: 1)),
                .init(color: .grLightBlackColor, position: CGPoint(x: 1, y: .zero))
            ]
        case 1:
            return [
                .init(color: .grDarkGrayColor, position: CGPoint(x: .zero, y: 1)),
                .init(color: .grLightGrayColor, position: CGPoint(x: 1, y: .zero))
            ]
        case 2:
            return [
                .init(color: .grLightGrayColor, position: CGPoint(x: .zero, y: 1)),
                .init(color: .grDarkGrayColor, position: CGPoint(x: 1, y: .zero))
            ]
        default:
            return []
        }
    }

    private func updateGradient(animated: Bool) {
        let gradientModels = getGradientColors(for: currentPageIndex)
        let colors = gradientModels.map({ $0.color })
        let positions = gradientModels.map({ $0.position })
        gradientLayer.setGradientColors(colors: colors,
                                        positions: positions,
                                        animated: animated)
    }

    private func updateGradient(_ percent: CGFloat) {
        let positivePercent = abs(percent)
        guard positivePercent != .zero && positivePercent != 1.0 else { return }

        let fromPageIndex = currentPageIndex
        var toPageIndex = currentPageIndex
        if percent >= .zero {
            // going right
            toPageIndex += 1
        } else {
            // going left
            toPageIndex -= 1
        }

        let fromColors = getGradientColors(for: fromPageIndex)
        let toColors = getGradientColors(for: toPageIndex)

        guard !fromColors.isEmpty, fromColors.count == toColors.count else { return }

        var colors: [UIColor] = []
        var positions: [CGPoint] = []
        for (index, item) in fromColors.enumerated() {
            let fromColor = item.color
            let toColor = toColors[index].color
            let currentColor = UIColor.colorBetween(fromColor: fromColor, toColor: toColor, percent: positivePercent)
            colors.append(currentColor)
            positions.append(item.position)
        }

        gradientLayer.setGradientColors(colors: colors,
                                        positions: positions,
                                        animated: false)
    }

    private func updatePageControl(isVisible: Bool) {
        let delay: TimeInterval = isVisible ? 0.5 : .zero
        let alpha: CGFloat = isVisible ? AlphaState.visible.rawValue : AlphaState.invisible.rawValue
        UIView.animate(withDuration: AnimationTime.fast.rawValue, delay: delay, options: .curveEaseOut) {
            self.pageControl.alpha = alpha
        }
    }

    private func updateCardsViewFrame() {
        cardBackView.adjustFrame(inView: cardsImageViewContainer)
        cardFrontView.adjustFrame(inView: cardsImageViewContainer)
        isCardBackImageVisible ? cardBackView.superview?.bringSubviewToFront(cardBackView) : ()
        isCardAnimationInProgress = false
    }

    private func flipCardsView(option: UIView.AnimationOptions) {
        guard !isCardAnimationInProgress else { return }
        let toView: UIView = isCardBackImageVisible ? cardFrontView : cardBackView
        let fromView: UIView = isCardBackImageVisible ? cardBackView : cardFrontView
        cardBackView.isHidden = false
        isCardAnimationInProgress = true
        updateCardShadow()
        DispatchQueue.main.async {
            UIView.transition(from: fromView,
                              to: toView,
                              duration: AnimationTime.verySlow.rawValue,
                              options: option) { isFinished in
                guard isFinished else { return }
                self.isCardBackImageVisible.toggle()
                self.isCardAnimationInProgress.toggle()
                self.updateCardShadow()
                self.flipToFrontOnFirstPage()
            }
        }
    }

    private func updateCardShadow() {
        isCardAnimationInProgress ? cardsImageViewContainer.removeShadow() : cardsImageViewContainer.addShadow()
    }
}

// MARK: - UIPageViewControllerDataSource Extension

extension CardsPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = index(of: viewController)
        if index != -1 {
            index -= 1
        }
        if index < .zero {
            return nil
        } else {
            return viewControllers[index]
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = index(of: viewController)
        if index != -1 {
            index += 1
        }
        if index >= viewControllers.count {
            return nil
        } else {
            return viewControllers[index]
        }
    }
}

// MARK: - UIPageViewControllerDelegate Extension

extension CardsPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed, let lastVC = pageViewController.viewControllers?.last,
              let index = viewControllers.firstIndex(of: lastVC) else { return }
        scrollPositionUpdated(pageIndex: index)
    }
}

// MARK: - UIPageViewControllerDelegate Extension

extension CardsPageViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Prevent bouncing on edges
        if currentPageIndex == .zero && scrollView.contentOffset.x <= scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: .zero)
        } else if currentPageIndex == viewControllers.count - 1 &&
                    scrollView.contentOffset.x >= scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: .zero)
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        decelerate ? scrollView.isUserInteractionEnabled = false : ()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Prevent bouncing on edges
        if currentPageIndex == .zero && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: .zero)
        } else if currentPageIndex == viewControllers.count - 1 &&
                    scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: .zero)
        }

        var direction: CGFloat = .zero // scroll stopped
        if startOffset < scrollView.contentOffset.x {
            direction = 1 // going right
        } else if startOffset > scrollView.contentOffset.x {
            direction = -1 // going left
        }

        let positionFromStartOfCurrentPage = abs(startOffset - scrollView.contentOffset.x)
        let percent = positionFromStartOfCurrentPage / view.frame.width
        let directedPercent = CGFloat(percent) * CGFloat(direction)

        updateScrollPosition(directedPercent)
        updateGradient(directedPercent)
    }
}
