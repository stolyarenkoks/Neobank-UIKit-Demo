//
//  CardTableCell.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - CardTableCell

class CardTableCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet private var containerView: UIView!
    @IBOutlet private var gradientView: UIView!
    @IBOutlet private var cardTitleLabel: UILabel!
    @IBOutlet private var cardBalanceLabel: UILabel!

    // MARK: - Private Properties

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.locations = [0, 1]
        return gradientLayer
    }()

    private var gradientViewBoundsObserver: NSKeyValueObservation?

    // MARK: - View Lifecycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
        setupGradient()
    }

    // MARK: - Setup

    private func setupView() {
        containerView.layer.cornerRadius = 20.0
        containerView.clipsToBounds = true

        cardTitleLabel.textColor = .gunmetalColor
        cardBalanceLabel.textColor = .gunmetalColor
    }

    private func setupGradient() {
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradientLayer, at: .zero)

        gradientViewBoundsObserver = observe(\.gradientView.bounds, options: [.new]) { [weak self] _, bounds in
            guard let gradientViewBounds = bounds.newValue else { return }
            self?.gradientLayer.frame = gradientViewBounds
            self?.gradientViewBoundsObserver = nil
        }
    }

    // MARK: - Internal Methods

    func setupCell(with cardModel: Card) {
        cardTitleLabel.text = cardModel.cardType.title
        cardBalanceLabel.text = cardModel.formattedBalance
        gradientView.backgroundColor = cardModel.cardType.gradientModels.first?.color
        updateGradient(gradientModels: cardModel.cardType.gradientModels)
    }

    // MARK: - Private Methods

    private func updateGradient(gradientModels: [GradientViewModel]) {
        let colors = gradientModels.map({ $0.color })
        let positions = gradientModels.map({ $0.position })
        gradientLayer.setGradientColors(colors: colors,
                                        positions: positions,
                                        animated: false)
    }
}
