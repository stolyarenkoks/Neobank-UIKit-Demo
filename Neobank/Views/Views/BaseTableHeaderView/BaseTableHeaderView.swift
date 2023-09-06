//
//  BaseTableHeaderView.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - BaseTableHeaderView

class BaseTableHeaderView: UITableViewHeaderFooterView {

    // MARK: - Outlets

    @IBOutlet private var headerTitleLabel: UILabel!

    // MARK: - View Lifecycle Properties

    override var reuseIdentifier: String? {
        return Const.BaseTableHeaderView.viewId
    }

    // MARK: - View Lifecycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        headerTitleLabel.textColor = .gunmetalColor.withAlphaComponent(0.4)
    }

    // MARK: - Internal Methods

    func setupView(with date: Date) {
        if date.isToday {
            headerTitleLabel.text = Const.General.todayTitle
        } else if date.isYesterday {
            headerTitleLabel.text = Const.General.yesterdayTitle
        } else {
            headerTitleLabel.text = FormattersManager.shared.dateFormatter.string(from: date)
        }
    }

    func setupView(with string: String) {
        headerTitleLabel.text = string
    }
}
