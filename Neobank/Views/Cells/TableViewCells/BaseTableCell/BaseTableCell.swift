//
//  BaseTableCell.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - BaseTableCell

class BaseTableCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet private var leftImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var rightLabel: UILabel!

    // MARK: - View Lifecycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        leftImageView.layer.cornerRadius = leftImageView.frame.size.height / 2
        titleLabel.textColor = .gunmetalColor
        subtitleLabel.textColor = .gunmetalColor.withAlphaComponent(0.4)
    }

    // MARK: - Internal Methods

    func setupCell(with transactionModel: Transaction) {
        titleLabel.text = transactionModel.title
        subtitleLabel.text = transactionModel.subtitle
        leftImageView.image = transactionModel.image ?? transactionModel.type.placeholderImage
        rightLabel.text = FormattersManager.shared.balanceString(from: transactionModel.amount)
        rightLabel.textColor = transactionModel.type.textColor
    }

    func setupCell(with viewModel: CardDetailViewModel) {
        titleLabel.text = viewModel.title
        if let subtitle = viewModel.subtitle {
            subtitleLabel.text = subtitle
        } else {
            subtitleLabel.isHidden = true
        }
        leftImageView.image = viewModel.image.applyingSymbolConfiguration(.init(pointSize: 50, weight: .thin, scale: .small))
        leftImageView.tintColor = .fireOpalColor
        rightLabel.isHidden = true
    }
}
