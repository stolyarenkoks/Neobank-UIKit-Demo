//
//  AwardHeaderView.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - AwardHeaderView

class AwardHeaderView: UICollectionReusableView {

    // MARK: - Outlets

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!

    // MARK: - View Lifecycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        imageView.image = UIImage(named: "awards-main-icon")
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }

    // MARK: - Internal Methods

    func updateTitle(_ title: String) {
        titleLabel.text = title
    }
}
