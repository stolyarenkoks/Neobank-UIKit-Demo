//
//  AwardCollectionViewCell.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - AwardCollectionViewCell

class AwardCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var imageViewContainerView: UIView!
    @IBOutlet private var titleLabel: UILabel!

    // MARK: - View Lifecycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        imageViewContainerView.layer.cornerRadius = imageViewContainerView.frame.size.height / 2
        imageViewContainerView.clipsToBounds = true
        imageViewContainerView.backgroundColor = .darkGunmetalColor
        imageViewContainerView.layer.borderWidth = 3.0

        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
    }

    // MARK: - Internal Methods

    internal func setupCell(with award: Award) {
        titleLabel.text = award.title

        let placeholderImage = UIImage(named: "award-placeholder-icon")
        let awardImage = award.image ?? placeholderImage
        imageView.image = award.isAchived ? awardImage : placeholderImage

        let color = award.isAchived ? UIColor.middleGreenColor : .onyxBlackColor
        imageViewContainerView.layer.borderColor = color.cgColor
    }
}
