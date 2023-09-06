//
//  UITabBar+Extensions.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - UITabBarController Extension

extension UITabBarController {

    /// Is the tab bar currently off the screen.
    var isTabBarHidden: Bool {
        tabBar.frame.origin.y >= UIScreen.main.bounds.height
    }

    /// Extends the size of the `UITabBarController` view frame, pushing the tab bar controller off screen.
    /// - Parameters:
    ///   - hidden: Hide or Show the `UITabBar`
    ///   - animated: Animate the change
    func setTabBarHidden(_ hidden: Bool, animated: Bool, duration: TimeInterval) {
        guard let vc = selectedViewController else { return }
        guard isTabBarHidden != hidden else { return }

        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = hidden ? height : -height
        let animatableDuration = animated ? duration : .zero

        let animator = UIViewPropertyAnimator(duration: animatableDuration, curve: .easeOut) {
            self.tabBar.frame = self.tabBar.frame.offsetBy(dx: .zero, dy: offsetY)
            self.selectedViewController?.view.frame = CGRect(x: 0,
                                                             y: 0,
                                                             width: vc.view.frame.width,
                                                             height: vc.view.frame.height + offsetY)

            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }

        animator.startAnimation()
    }

    func setTabBarPosition(yPosition: CGFloat) {
        tabBar.frame = CGRect(x: tabBar.frame.origin.x,
                              y: yPosition,
                              width: tabBar.frame.size.width,
                              height: tabBar.frame.size.height)

        view.setNeedsDisplay()
        view.layoutIfNeeded()
    }
}
