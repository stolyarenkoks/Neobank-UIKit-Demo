//
//  UIView+Extensions.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - UIView Helpers Extension

extension UIView {

    func adjustFrame(inView view: UIView) {
        frame = view.bounds
        view.addSubview(self)
    }

    func pinEdges(toView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .zero).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .zero).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: .zero).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: .zero).isActive = true
    }
}

// MARK: - UIView LoadView Extension

extension UIView {

    static func loadFromNib<T>() -> T where T: UIView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
}

// MARK: - UIView Shadow Extension

extension UIView {

    func addShadow(radius: CGFloat = 6.0,
                   opacity: Float = 0.3,
                   width: CGFloat = 0.0,
                   height: CGFloat = 5.0,
                   color: UIColor = .gunmetalColor) {
        UIView.animate(withDuration: AnimationTime.quiteFast.rawValue) {
            self.layer.masksToBounds = false
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOpacity = opacity
            self.layer.shadowOffset = CGSize(width: width, height: height)
            self.layer.shadowRadius = radius
        }
    }

    func removeShadow() {
        UIView.animate(withDuration: AnimationTime.extremelyFast.rawValue) {
            self.layer.masksToBounds = true
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.shadowOpacity = .zero
            self.layer.shadowOffset = .zero
            self.layer.shadowRadius = .zero
        }
    }
}
