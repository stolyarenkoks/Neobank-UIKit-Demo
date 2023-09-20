//
//  CardsMenuPageViewController.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - CardsMenuViewController

class CardsMenuPageViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet private var segmentedControl: CustomSegmentedControl!

    // MARK: - Internal Properties

    var swipeInteractionController: SwipeInteractionController?

    // MARK: - Private Properties

    private var pageController: UIPageViewController!
    private var viewControllers: [UIViewController] = []
    private var currentPageIndex: Int = .zero
    private var startOffset: CGFloat = .zero

    private lazy var mainCardsViewController: MainCardsViewController! = {
        Storyboard.cardsMenu.instantiateVC(MainCardsViewController.self)
    }()

    private lazy var childrenViewController: ChildrenViewController! = {
        Storyboard.cardsMenu.instantiateVC(ChildrenViewController.self)
    }()

    private lazy var businessViewController: BusinessViewController! = {
        Storyboard.cardsMenu.instantiateVC(BusinessViewController.self)
    }()

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageViewController()
        setupSegmentedControl()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updatePageControllerFrame()
    }

    // MARK: - Setup

    override func setupUI() {
        view.backgroundColor = .darkGunmetalColor
    }

    override func setupSettings() {
        swipeInteractionController = SwipeInteractionController(rootViewController: self,
                                                                animatedViewController: self)
    }

    private func setupPageViewController() {
        viewControllers = [
            mainCardsViewController,
            childrenViewController,
            businessViewController
        ]

        currentPageIndex = .zero

        pageController = UIPageViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: nil)
        pageController.view.backgroundColor = UIColor.clear
        pageController.delegate = self
        pageController.dataSource = self

        let screollViews = pageController.view.subviews as? [UIScrollView] ?? []
        for svScroll in screollViews {
            svScroll.delegate = self
        }

        pageController.setViewControllers([viewControllers[currentPageIndex]],
                                          direction: .forward,
                                          animated: false,
                                          completion: nil)
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)

        updatePageControllerFrame()
    }

    private func setupSegmentedControl() {
        segmentedControl.selectorColor = .fireOpalColor
        segmentedControl.segmentedControlViewModels = MockDataManager.shared.generateSegmentsDataSource()
        segmentedControl.addTarget(self, action: #selector(onChangeOfSegment(_:)), for: .valueChanged)
    }

    // MARK: - Private Methods

    private func updatePageControllerFrame() {
        pageController.view.frame = CGRect(x: 0,
                                           y: segmentedControl.frame.maxY,
                                           width: UIScreen.main.bounds.width,
                                           height: UIScreen.main.bounds.height - segmentedControl.frame.maxY)
    }

    private func index(of viewController: UIViewController) -> Int {
        if viewControllers.contains(viewController) {
            return viewControllers.firstIndex(of: viewController)!
        }
        return -1
    }

    @objc private func onChangeOfSegment(_ sender: CustomSegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            pageController.setViewControllers([viewControllers[0]], direction: .reverse, animated: true, completion: nil)
            currentPageIndex = .zero
        case 1:
            if currentPageIndex > 1 {
                pageController.setViewControllers([viewControllers[1]], direction: .reverse, animated: true, completion: nil)
                currentPageIndex = 1
            } else {
                pageController.setViewControllers([viewControllers[1]], direction: .forward, animated: true, completion: nil)
                currentPageIndex = 1
            }
        case 2:
            if currentPageIndex < 2 {
                pageController.setViewControllers([viewControllers[2]], direction: .forward, animated: true, completion: nil)
                currentPageIndex = 2
            } else {
                pageController.setViewControllers([viewControllers[2]], direction: .reverse, animated: true, completion: nil)
                currentPageIndex = 2
            }
        default:
            break
        }
    }
}

// MARK: - UIPageViewControllerDataSource Extension

extension CardsMenuPageViewController: UIPageViewControllerDataSource {

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

extension CardsMenuPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed, let lastVC = pageViewController.viewControllers?.last,
              let index = viewControllers.firstIndex(of: lastVC) else { return }
        currentPageIndex = index
        segmentedControl.updateSegments(at: currentPageIndex)
    }
}

// MARK: - UIPageViewControllerDelegate Extension

extension CardsMenuPageViewController: UIScrollViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var direction: CGFloat = .zero // scroll stopped
        if startOffset < scrollView.contentOffset.x {
            direction = 1 // going right
        } else if startOffset > scrollView.contentOffset.x {
            direction = -1 // going left
        }
        let positionFromStartOfCurrentPage = abs(startOffset - scrollView.contentOffset.x)
        let percent = positionFromStartOfCurrentPage / view.frame.width
        let directedPercent = CGFloat(percent) * CGFloat(direction)
        segmentedControl.updateSelectorViewPosition(directedPercent)
    }
}
