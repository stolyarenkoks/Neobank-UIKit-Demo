//
//  GradientViewModel.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - Gradient ViewModel

struct GradientViewModel {

    // MARK: - Internal Properties

    let color: UIColor
    let position: CGPoint
}

// MARK: - Gradient Mock Extension

extension GradientViewModel {

    static func mock(color: UIColor = UIColor(hexString: "FBC2EB"),
                     position: CGPoint = .zero) -> Self {
        .init(color: color,
              position: position)
    }
}
