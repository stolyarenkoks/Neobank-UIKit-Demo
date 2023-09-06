//
//  Date+Extensions.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import Foundation

// MARK: - Date Extension

extension Date {

    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }

    var dayBefore: Date {
        let oneDay: TimeInterval = 24 * 60 * 60
        return self.addingTimeInterval(-oneDay)
    }

    func removeTime() -> Date {
        return Calendar.current.startOfDay(for: self)
    }

    init?(dateString: String) {
        guard let date = FormattersManager.shared.date(from: dateString) else { return nil }
        self = date
    }
}
