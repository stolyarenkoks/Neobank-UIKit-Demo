//
//  MainCardsViewController.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - MainCardsViewController

class MainCardsViewController: BaseViewController {

    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var newCardButton: UIButton!

    // MARK: - Private Properties

    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.locations = [0, 1]
        return gradientLayer
    }()

    private var cards: [Card] = []

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradient()
        setupCards()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.contentInset = UIEdgeInsets(top: 16, left: .zero, bottom: .zero, right: .zero)
    }

    // MARK: - Setup

    override func setupUI() {
        newCardButton.layer.cornerRadius = 12
        newCardButton.layer.borderWidth = 1.5
        newCardButton.layer.borderColor = UIColor.ghostWhiteColor.cgColor
        newCardButton.setTitleColor(.ghostWhiteColor, for: .normal)
        newCardButton.titleLabel?.font = .poppins(.regular, size: 20)
        newCardButton.setImage(UIImage(systemName: "plus.app")?.applyingSymbolConfiguration(.init(scale: .large)), for: .normal)
        newCardButton.tintColor = .ghostWhiteColor
        newCardButton.setTitle(Const.MainCardsViewController.newCardButtonTitle, for: .normal)
        newCardButton.imageView?.contentMode = .scaleAspectFit
        newCardButton.imageEdgeInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: 24)
    }

    override func setupSettings() {
        tableView.register(nibName: Const.CardTableCell.cellNibName, cellId: Const.CardTableCell.cellId)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupGradient() {
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: .zero)
        updateGradient(animated: false)
    }

    private func setupCards() {
        cards = MockDataManager.shared.generateCardsDataSource()
        tableView.reloadData()
    }

    // MARK: - Actions

    @IBAction private func newCardButtonTapped(_ sender: Any) {
        dismissController()
    }

    // MARK: - Private Methods

    private func dismissController() {
        dismiss(animated: true, completion: nil)
    }

    private func updateGradient(animated: Bool) {
        let gradientModels = [
            GradientViewModel(color: .chineseBlackColor, position: .zero),
            GradientViewModel(color: .lightGunmetalColor, position: CGPoint(x: .zero, y: 1))
        ]
        let colors = gradientModels.map({ $0.color })
        let positions = gradientModels.map({ $0.position })
        gradientLayer.setGradientColors(colors: colors,
                                        positions: positions,
                                        animated: animated)
    }
}

// MARK: - UITableViewDataSource Extension

extension MainCardsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cardTableCell = tableView.dequeueReusableCell(withIdentifier: Const.CardTableCell.cellId,
                                                                for: indexPath) as? CardTableCell else {
            return UITableViewCell()
        }
        let cardModel = cards[indexPath.row]
        cardTableCell.setupCell(with: cardModel)
        return cardTableCell
    }
}

// MARK: - UITableViewDelegate Extension

extension MainCardsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        dismissController()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.CardTableCell.cellHeight
    }
}
