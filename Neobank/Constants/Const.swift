//
//  Const.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - AnimationTime Enum

enum AnimationTime: TimeInterval {
    case slowest = 1.0
    case extremelySlow = 0.9
    case verySlow = 0.8
    case quiteSlow = 0.7
    case slow = 0.6
    case `default` = 0.5
    case fast = 0.4
    case quiteFast = 0.3
    case veryFast = 0.2
    case extremelyFast = 0.1
    case fastest = 0.0
}

// MARK: - AlphaState Enum

enum AlphaState: CGFloat {
    case visible = 1.0
    case translucent = 0.5
    case invisible = 0.0
}

// MARK: - Const

struct Const {

    // MARK: - General

    struct General {
        static let reuseIdPostfix = "ReuseIdentifier"

        static let cancelTitle = "Cancel"
        static let clearTitle = "Clear"
        static let restoreTitle = "Restore"
        static let editTitle = "Edit"
        static let addTitle = "Add"
        static let doneTitle = "Done"
        static let deleteTitle = "Delete"
        static let cloneTitle = "Clone"
        static let reconnectTitle = "Reconnect"
        static let removeTitle = "Remove"
        static let resetTitle = "Reset"
        static let saveTitle = "Save"
        static let todayTitle = "Today"
        static let yesterdayTitle = "Yesterday"

        static let hashSymbol = "#"
        static let commaSymbol = ","
        static let dotSymbol = "."
        static let colonSymbol = ":"
        static let perCentSymbol = "%"

        static let filledStar = "★"
        static let unfilledStar = "☆"
    }

    // MARK: - Models

    struct Currency {
        static let hryvniaSymbol = "₴"
        static let dollarSymbol = "$"
        static let euroSymbol = "€"
    }

    struct Card {
        static let platinumTitle = "Platinum"
        static let whiteTitle = "White"
        static let dollarTitle = "USD"
        static let euroTitle = "EUR"
    }

    // MARK: - TabBar

    struct TabBar {
        static let cardItemTitle = "Card"
        static let creditsItemTitle = "Credit"
        static let profileItemTitle = "Profile"
    }

    // MARK: - TableView Headers

    struct BaseTableHeaderView {
        static let viewNibName = "BaseTableHeaderView"
        static let viewId = viewNibName + General.reuseIdPostfix

        static let viewHeight: CGFloat = 50
    }

    // MARK: - TableView Cells

    struct CardTableCell {
        static let cellNibName = "CardTableCell"
        static let cellId = cellNibName + General.reuseIdPostfix

        static let cellHeight: CGFloat = 90.0
    }

    struct BaseTableCell {
        static let cellNibName = "BaseTableCell"
        static let cellId = cellNibName + General.reuseIdPostfix

        static let cellHeight: CGFloat = 64.0
    }

    // MARK: - CollectionView Headers

    struct AwardHeaderView {
        static let viewNibName = "AwardHeaderView"
        static let viewId = viewNibName + General.reuseIdPostfix

        static let achivedAwardsFormat = "You unlocked %i reward from %i 🚀"
    }

    // MARK: - CollectionView Cells

    struct AwardCollectionViewCell {
        static let cellNibName = "AwardCollectionViewCell"
        static let cellId = cellNibName + General.reuseIdPostfix

        static let cellSize = CGSize(width: 100, height: 115)
    }

    // MARK: - ViewControllers

    struct MainCardsViewController {
        static let newCardButtonTitle = "Open New Card"
    }

    struct CardsPageViewController {
        static let pageControlHeight: CGFloat = 28.0
        static let cardContainerAspectRatio: CGFloat = 0.66
        static let pageIndicatorHeight: CGFloat = 40.0
    }

    struct AwardsViewController {
        static let collectionViewEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let collectionViewMinimumLineSpacing: CGFloat = 16.0
        static let pageControlVisibleOffset: CGFloat = 10.0
    }

    struct CardViewController {
        static let bottomSheetMaxHeightOffset: CGFloat = 26.0
        static let buttonsViewHeight: CGFloat = 111.0
    }

    struct CardDetailViewController {
        static let bottomSheetMaxHeightOffset: CGFloat = 26.0
        static let buttonsViewHeight: CGFloat = 111.0
    }

    struct DemoViewController {
        static let title = "Demo Mode"
        static let description = "We're sorry, but this section is not available in Demo Mode"
    }
}
