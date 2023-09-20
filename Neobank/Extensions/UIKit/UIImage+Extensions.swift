//
//  UIImage+Extensions.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - TODO: Refactor Images

// MARK: - UIImage Extension

extension UIImage {

    // MARK: - Models

    struct Transaction {
        static let incomingTransactionImage = UIImage(systemName: "arrow.uturn.down")
        static let outgoingTransactionImage = UIImage(systemName: "arrow.uturn.forward")
    }

    // MARK: - ViewControllers

    struct CardDetailViewModel {
        static let applePayImage = UIImage(systemName: "personalhotspot.circle")!
    }
}
