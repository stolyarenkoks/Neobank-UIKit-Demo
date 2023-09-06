//
//  CardFrontView.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - CardFrontView

class CardFrontView: UIView {

    // MARK: - Outlets

    @IBOutlet private var logoLabel: UILabel!
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var holderNameLabel: UILabel!

    // MARK: - View Lifecycle Methods

    static func instantiate() -> CardFrontView {
        let view: CardFrontView = CardFrontView.loadFromNib()
        return view
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        backgroundImageView.contentMode = .scaleAspectFit

        holderNameLabel.text = "Neobank"
        logoLabel.textColor = .lightGunmetalColor

        holderNameLabel.text = "Konstantin Stolyarenko".uppercased()
        holderNameLabel.textColor = .lightGunmetalColor
    }
}
