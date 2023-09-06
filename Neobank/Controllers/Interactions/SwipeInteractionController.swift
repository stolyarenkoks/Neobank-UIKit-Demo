//
//  SwipeInteractionController.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - SwipeInteractionController

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {

    // MARK: - Internal Properties

    var interactionInProgress = false {
        didSet {
            if let cardViewController = rootViewController as? CardViewController,
               let pageViewController = cardViewController.pageViewController {
                pageViewController.isEnableScrolling = !interactionInProgress
            }
        }
    }

    // MARK: - Private Properties

    private var rootViewController: UIViewController!
    private var animatedViewController: UIViewController!
    private var isPresentInteraction: Bool = false
    private var shouldCompleteTransition = false

    private var isCardPageDragInProgress: Bool {
        if let cardViewController = rootViewController as? CardViewController,
           let pageViewController = cardViewController.pageViewController,
           pageViewController.isDragInProgress {
            return true
        }
        return false
    }

    private var isBottomSheetTopOrInProgress: Bool {
        if let cardViewController = rootViewController as? CardViewController,
           cardViewController.isBottomSheetTopOrInProgress {
            return true
        }
        return false
    }

    private var isCardsMenuPresentationAllowed: Bool {
        !isCardPageDragInProgress && !isBottomSheetTopOrInProgress
    }

    // MARK: - Init

    init(rootViewController: UIViewController,
         animatedViewController: UIViewController,
         isPresentInteraction: Bool = false) {
        super.init()

        self.rootViewController = rootViewController
        self.animatedViewController = animatedViewController
        self.isPresentInteraction = isPresentInteraction

        setupGestureRecognizer()
    }

    // MARK: - Setup

    private func setupGestureRecognizer() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.delegate = self
        rootViewController.view.addGestureRecognizer(gesture)
    }

    // MARK: - Private Methods

    @objc private func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard isCardsMenuPresentationAllowed else { return }
        isPresentInteraction ? handlePresentGesture(gestureRecognizer) : handleDismissGesture(gestureRecognizer)
    }

    private func handlePresentGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        let progress = translation.y / rootViewController.view.frame.size.height
        let weightedProgress = CGFloat(fminf(fmaxf(Float(progress), .zero), 1.0))
        switch gestureRecognizer.state {
        case .changed:
            if animatedViewController.isBeingPresented {
                shouldCompleteTransition = weightedProgress > 0.3
                update(progress)
            } else {
                guard progress > .zero, abs(translation.y) > abs(translation.x) else { return }
                interactionInProgress = true
                rootViewController.present(animatedViewController, animated: true, completion: nil)
            }
        case .cancelled, .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }

    private func handleDismissGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        let progress = -(translation.y / rootViewController.view.frame.size.height)
        let weightedProgress = CGFloat(fminf(fmaxf(Float(progress), .zero), 1.0))
        switch gestureRecognizer.state {
        case .began:
            guard progress >= .zero else { return }
            interactionInProgress = true
            animatedViewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = weightedProgress > 0.2
            update(progress)
        case .cancelled, .ended:
            interactionInProgress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate Extension

extension SwipeInteractionController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer,
           let superview = gestureRecognizer.view?.superview {
            let translation = panGestureRecognizer.translation(in: superview)

            let yTranslation = translation.y / rootViewController.view.frame.size.height
            let xTranslation = translation.x / rootViewController.view.frame.size.height
            let isHorizontal = xTranslation != .zero && yTranslation == .zero
            let isCardsMenu = rootViewController.isKind(of: CardsMenuPageViewController.self)

            if isCardsMenu {
                if !isHorizontal {
                    return true
                }
            } else {
                if isHorizontal {
                    return true
                }
            }
        }
        return false
    }
}
