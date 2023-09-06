//
//  Storyboard.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - Storyboard Enum

enum Storyboard: String {
    case base = "Main"
    case card = "Card"
    case cardsMenu = "CardsMenu"
    case demo = "Demo"

    // MARK: - Internal Methods

    func instantiateVC<T>(_ identifier: T.Type) -> T {
        let identifier = String(describing: identifier)
        let storyboard = UIStoryboard(name: rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
