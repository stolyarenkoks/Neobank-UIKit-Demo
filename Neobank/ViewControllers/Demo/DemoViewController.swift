//
//  DemoViewController.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - DemoViewController

class DemoViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    // MARK: - Private Properties

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.locations = [0, 1]
        return gradientLayer
    }()

    // MARK: - ViewController Lifecycle Properties

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradient()
    }

    // MARK: - Setup

    override func setupUI() {
        titleLabel.text = Const.DemoViewController.title
        titleLabel.textColor = .whiteColor

        descriptionLabel.text = Const.DemoViewController.description
        descriptionLabel.textColor = .whiteColor.withAlphaComponent(0.6)
    }

    override func setupSettings() {}

    private func setupGradient() {
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: .zero)
        updateGradient(animated: false)
    }

    // MARK: - Private Methods

    private func updateGradient(animated: Bool) {
        let gradientModels = [
            GradientViewModel(color: .philippineSilverColor, position: CGPoint(x: 1, y: .zero)),
            GradientViewModel(color: .manateeGrayColor, position: CGPoint(x: .zero, y: 1))
        ]
        let colors = gradientModels.map({ $0.color })
        let positions = gradientModels.map({ $0.position })
        gradientLayer.setGradientColors(colors: colors,
                                        positions: positions,
                                        animated: animated)
    }
}
