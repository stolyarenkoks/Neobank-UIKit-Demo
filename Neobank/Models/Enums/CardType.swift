//
//  CardType.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import Foundation

// MARK: - CardType Enum

enum CardType {
    case platinum
    case white
    case dollar
    case euro

    // MARK: - Internal Properties

    var title: String {
        switch self {
        case .platinum:
            return Const.Card.platinumTitle
        case .white:
            return Const.Card.whiteTitle
        case .dollar:
            return Const.Card.dollarTitle
        case .euro:
            return Const.Card.euroTitle
        }
    }

    var currencySymbol: String {
        switch self {
        case .platinum:
            return Const.Currency.dollarSymbol
        case .white:
            return Const.Currency.hryvniaSymbol
        case .dollar:
            return Const.Currency.dollarSymbol
        case .euro:
            return Const.Currency.euroSymbol
        }
    }

    var gradientModels: [GradientViewModel] {
        switch self {
        case .platinum:
            return [
                GradientViewModel(color: .crayolaPeriwinkleColor, position: .zero),
                GradientViewModel(color: .lightCulturedWhiteColor, position: CGPoint(x: 1, y: 1))
            ]
        case .white:
            return [
                GradientViewModel(color: .whiteColor, position: .zero),
                GradientViewModel(color: .ghostWhiteColor, position: CGPoint(x: 1, y: 1))
            ]
        case .dollar:
            return [
                GradientViewModel(color: .ufoGreenColor, position: .zero),
                GradientViewModel(color: .mediumAquamarine, position: CGPoint(x: 1, y: 1))
            ]
        case .euro:
            return [
                GradientViewModel(color: .deepPeachColor, position: .zero),
                GradientViewModel(color: .fleshColor, position: CGPoint(x: 1, y: 1))
            ]
        }
    }
}
