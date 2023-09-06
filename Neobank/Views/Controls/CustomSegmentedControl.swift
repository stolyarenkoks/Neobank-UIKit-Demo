//
//  CustomSegmentedControl.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - CustomSegmented Control

@IBDesignable
class CustomSegmentedControl: UIControl {

    // MARK: - IBInspectables

    @IBInspectable var borderWidth: CGFloat = .zero {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat = .zero {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var baseTintColor: UIColor = .lightGray {
        didSet {
            updateView()
        }
    }

    @IBInspectable var selectedTintColor: UIColor = .green {
        didSet {
            updateView()
        }
    }

    @IBInspectable var selectorColor: UIColor = .darkGray {
        didSet {
            updateView()
        }
    }

    // MARK: - Internal Properties

    var selectedSegmentIndex: Int = .zero

    var segmentedControlViewModels: [SegmentViewModel] = [] {
        didSet {
            updateView()
        }
    }

    // MARK: - Private Properties

    private var buttons: [UIButton] = []
    private var selector: UIView!
    private var isCurrentPositionAnimated = true
    private let selectorLeftMargin: CGFloat = 16.0

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        updateView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        updateView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateSelectorFrame()
    }

    // MARK: - Internal Methods

    func updateSegments(at index: Int) {
        for button in buttons {
            button.setTitleColor(baseTintColor, for: .normal)
            button.tintColor = baseTintColor
        }

        let selectedButton = buttons[index]
        selectedButton.setTitleColor(selectedTintColor, for: .normal)
        selectedButton.tintColor = selectedTintColor
        selectedSegmentIndex = index
        let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(index)

        UIView.animate(withDuration: 0.3) {
            self.selector.frame.origin.x = self.selectorLeftMargin + selectorStartPosition
        } completion: { _ in
            self.isCurrentPositionAnimated = true
        }
    }

    func updateSelectorViewPosition(_ percent: CGFloat) {
        guard isCurrentPositionAnimated, percent != .zero else { return }
        let position = CGFloat(selectedSegmentIndex) + percent
        let selectorStartPosition = frame.width / CGFloat(buttons.count) * CGFloat(position)
        selector.frame.origin.x = selectorLeftMargin + selectorStartPosition
    }

    // MARK: - Private Methods

    private func updateView() {
        backgroundColor = .clear
        buttons.removeAll()
        subviews.forEach { view in
            view.removeFromSuperview()
        }

        for viewModel in segmentedControlViewModels {
            let button = UIButton(type: .system)
            button.backgroundColor = .clear
            button.setTitle(viewModel.title, for: .normal)
            button.setImage(viewModel.image, for: .normal)
            button.setTitleColor(baseTintColor, for: .normal)
            button.tintColor = baseTintColor
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: 16)
            button.titleLabel?.font = .poppins(.regular, size: 16)
            button.addTarget(self, action: #selector(segmentButtonTapped(segmentButton:)), for: .touchUpInside)
            buttons.append(button)
        }

        if let firstButton = buttons.first {
            firstButton.setTitleColor(selectedTintColor, for: .normal)
            firstButton.tintColor = selectedTintColor
        }

        selector = UIView(frame: .zero)
        selector.backgroundColor = selectorColor
        selector.layer.cornerRadius = 2
        selector.clipsToBounds = true
        addSubview(selector)
        updateSelectorFrame()

        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = .zero
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    @objc private func segmentButtonTapped(segmentButton: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: segmentButton) else { return }
        isCurrentPositionAnimated = false
        updateSegments(at: buttonIndex)
        sendActions(for: .valueChanged)
    }

    private func updateSelectorFrame() {
        let margins = selectorLeftMargin * 2
        let selectorWidth = (frame.width / CGFloat(segmentedControlViewModels.count)) - margins
        let y = (self.frame.maxY - self.frame.minY) - 3.0
        selector.frame = CGRect(x: selectorLeftMargin, y: y, width: selectorWidth, height: 2.0)
    }
}
