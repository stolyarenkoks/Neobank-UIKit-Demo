//
//  PresentCardsMenuTransition.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - PresentCardsMenuTransition

class PresentCardsMenuTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Internal Properties

    let interactionController: SwipeInteractionController?

    // MARK: - Private Properties

    private let fromViewFrame: CGRect
    private var animator: UIViewImplicitlyAnimating?

    // MARK: - Init

    init(fromViewFrame: CGRect, interactionController: SwipeInteractionController?) {
        self.fromViewFrame = fromViewFrame
        self.interactionController = interactionController
    }

    // MARK: - Internal Methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return AnimationTime.quiteFast.rawValue
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let animtaor = self.animator {
            return animtaor
        }

        let toVC = transitionContext.viewController(forKey: .to)!
        let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)!
        let containerView = transitionContext.containerView
        let toViewFrame = transitionContext.finalFrame(for: toVC)

        snapshot.frame = fromViewFrame
        snapshot.layer.cornerRadius = 15
        snapshot.layer.masksToBounds = true

        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.isHidden = true

        let animator = UIViewPropertyAnimator(duration: self.transitionDuration(using: transitionContext),
                                              curve: .easeInOut) {
            snapshot.frame = toViewFrame
            snapshot.layer.cornerRadius = .zero
        }

        animator.addCompletion { _ in
            if transitionContext.transitionWasCancelled {
                toVC.view.isHidden = false
            } else {
                toVC.view.isHidden = false
                snapshot.removeFromSuperview()
            }

            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        self.animator = animator
        return animator
    }

    func animationEnded(_ transitionCompleted: Bool) {
        self.animator = nil
    }
}
