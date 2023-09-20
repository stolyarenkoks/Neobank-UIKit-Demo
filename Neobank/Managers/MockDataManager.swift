//
//  MockDataManager.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - MockData Manager

class MockDataManager {

    // MARK: - Singleton

    static let shared = MockDataManager()

    // MARK: - Init

    private init() {}

    // MARK: - Internal Methods

    func generateAwardsDataSource() -> [Award] {
        [
            .mock(title: "Introduction",
                  description: "The profile is completely filled out",
                  image: UIImage(named: "award-intro-icon"),
                  isAchived: true),
            .mock(title: "Elite"),
            .mock(title: "Star"),
            .mock(title: "Companion"),
            .mock(title: "Passenger"),
            .mock(title: "Minibus"),
            .mock(title: "Surprise"),
            .mock(title: "Enlightenment"),
            .mock(title: "Connection"),
            .mock(title: "Insider"),
            .mock(title: "Car"),
            .mock(title: "Train"),
            .mock(title: "Flight"),
            .mock(title: "Mate"),
            .mock(title: "Friend")
        ]
    }

    func generateSegmentsDataSource() -> [SegmentViewModel] {
        [
            .mock(title: "Cards"),
            .mock(title: "Children"),
            .mock(title: "Business")
        ]
    }

    func generateCardsDataSource() -> [Card] {
        [
            .mock(cardType: .platinum, balance: 100_000),
            .mock(cardType: .white, balance: 20_000),
            .mock(cardType: .dollar, balance: 6_000),
            .mock(cardType: .euro, balance: 8_000)
        ]
    }

    func generateTransactionsDataSource() -> [Transaction] {
        [
            .mock(),
            .mock(amount: 350,
                  title: "From euro card",
                  subtitle: "Card replenishment",
                  image: nil),
            .mock(type: .outgoing,
                  amount: -50,
                  title: "Apple",
                  subtitle: "Games",
                  image: UIImage(systemName: "apple.logo")),
            .mock(type: .outgoing,
                  amount: -550,
                  title: "Dad",
                  subtitle: "Transfer",
                  image: nil),
            .mock(type: .outgoing,
                  amount: -10,
                  title: "Apple",
                  subtitle: "Games",
                  image: UIImage(systemName: "apple.logo")),
            .mock(date: Date().dayBefore),
            .mock(date: Date().dayBefore,
                  amount: 350,
                  title: "From euro card",
                  subtitle: "Card replenishment",
                  image: nil),
            .mock(type: .outgoing,
                  date: Date().dayBefore,
                  amount: -550,
                  title: "Dad",
                  subtitle: "Transfer",
                  image: nil),
            .mock(date: Date(dateString: "2022-03-22T10:44:00")!),
            .mock(type: .outgoing,
                  date: Date(dateString: "2022-03-22T10:44:00")!,
                  amount: -150,
                  title: "Apple",
                  subtitle: "Games",
                  image: UIImage(systemName: "apple.logo")),
            .mock(type: .outgoing,
                  date: Date(dateString: "2022-03-22T10:44:00")!,
                  amount: -550,
                  title: "Dad",
                  subtitle: "Transfer",
                  image: nil)
        ]
    }
}
