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

    // MARK: - Demo Images

    struct Demo {
        static let demoGameStoreImage = UIImage(named: "demo-game-store-icon")
        static let demoUserImage = UIImage(named: "demo-user-icon")
    }

    // MARK: - TabBar

    struct TabBar {
        static let cardUnselectedImage = UIImage(named: "tabBar-card-icon-unselected")
    }

    // MARK: - Models

    struct Transaction {
        static let incomingTransactionImage = UIImage(named: "incoming-transaction-icon")
        static let outgoingTransactionImage = UIImage(named: "outgoing-transaction-icon")
    }

    // MARK: - ViewControllers

    struct MainCardsViewController {
        static let addCardImage = UIImage(named: "add-card-icon")
    }

    struct CardDetailViewController {
        static let applePayImage = UIImage(named: "apple-pay-icon")
    }
}
