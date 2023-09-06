//
//  TransactionType.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - TransactionType Enum

enum TransactionType {
    case incoming
    case outgoing

    // MARK: - Internal Properties

    var placeholderImage: UIImage? {
        switch self {
        case .incoming:
            return UIImage.Transaction.incomingTransactionImage
        case .outgoing:
            return UIImage.Transaction.outgoingTransactionImage
        }
    }

    var textColor: UIColor {
        switch self {
        case .incoming:
            return .ufoGreenColor
        case .outgoing:
            return .lightGunmetalColor
        }
    }
}
