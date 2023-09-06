//
//  Transaction.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - Transaction Model

struct Transaction {

    // MARK: - Internal Properties

    let type: TransactionType
    let date: Date
    let amount: Double
    let title: String
    let subtitle: String
    let image: UIImage?
}

// MARK: - Transaction Mock Extension

extension Transaction {

    static func mock(type: TransactionType = .incoming,
                     date: Date = Date(),
                     amount: Double = 1_800,
                     title: String = "Kostya S.",
                     subtitle: String = "For good job!",
                     image: UIImage? = UIImage(named: "avatar-image")) -> Self {
        .init(type: type,
              date: date,
              amount: amount,
              title: title,
              subtitle: subtitle,
              image: image)
    }
}
