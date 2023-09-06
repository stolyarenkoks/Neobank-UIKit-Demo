//
//  DismissCardsMenuTransition.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - DismissCardsMenuTransition

class DismissCardsMenuTransition: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Internal Properties

    let interactionController: SwipeInteractionController?

    // MARK: - Private Properties

    private var animator: UIViewImplicitlyAnimating?

    // MARK: - Init

    init(interactionController: SwipeInteractionController?) {
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

        let fromVC = transitionContext.viewController(forKey: .from)!
        let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true)!
        let containerView = transitionContext.containerView

        snapshot.frame = fromVC.view.frame
        snapshot.alpha = AlphaState.visible.rawValue

        containerView.addSubview(snapshot)
        fromVC.view.isHidden = true

        var fromViewInitialFrame = transitionContext.initialFrame(for: fromVC)
        fromViewInitialFrame.origin.x = .zero
        var fromViewFinalFrame = fromViewInitialFrame
        fromViewFinalFrame.origin.y = -fromViewFinalFrame.height

        let animator = UIViewPropertyAnimator(duration: self.transitionDuration(using: transitionContext),
                                              curve: .easeInOut) {
            snapshot.alpha = AlphaState.invisible.rawValue
        }

        animator.addCompletion { _ in
            if transitionContext.transitionWasCancelled {
                fromVC.view.isHidden = false
                snapshot.removeFromSuperview()
            } else {
                fromVC.view.isHidden = false
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
