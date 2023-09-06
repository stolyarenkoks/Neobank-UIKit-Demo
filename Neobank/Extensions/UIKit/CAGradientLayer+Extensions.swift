//
//  CAGradientLayer+Extensions.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - CAGradientLayer Extension

extension CAGradientLayer {

    func setGradientColors(colors: [UIColor],
                           positions: [CGPoint],
                           animated: Bool = true,
                           duration: CFTimeInterval = AnimationTime.default.rawValue) {
        guard let startPoint = positions.first,
              let endPoint = positions.last else { return }
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.colors = colors.map { $0.cgColor }
            })
            let animation = CABasicAnimation(keyPath: "colors")
            animation.duration = duration
            animation.toValue = colors.map { $0.cgColor }
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.isRemovedOnCompletion = false
            add(animation, forKey: "changeColors")
            CATransaction.commit()
        } else {
            self.colors = colors.map { $0.cgColor }
        }
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
