//
//  FormattersManager.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import Foundation

// MARK: - FormattersManager

class FormattersManager {

    // MARK: - Singleton

    static let shared = FormattersManager()

    // MARK: - Internal Properties

    lazy var balanceFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()

    lazy var serverDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()

    // MARK: - Init

    private init() {}

    // MARK: - Internal Methods

    func date(from string: String) -> Date? {
        return serverDateFormatter.date(from: string)
    }

    func balanceString(from balance: Double) -> String {
        return balanceFormatter.string(from: balance as NSNumber)!
    }
}
