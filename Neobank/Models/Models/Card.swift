//
//  Card.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import Foundation

// MARK: - Card Model

struct Card {

    // MARK: - Internal Properties

    let cardType: CardType
    let balance: Double

    var formattedBalance: String {
        let balance = FormattersManager.shared.balanceString(from: balance)
        let fullBalanceString = "\(balance) \(cardType.currencySymbol)"
        return fullBalanceString
    }
}

// MARK: - Card Mock Extension

extension Card {

    static func mock(cardType: CardType = .platinum,
                     balance: Double = 100_000) -> Self {
        .init(cardType: cardType,
              balance: balance)
    }
}
