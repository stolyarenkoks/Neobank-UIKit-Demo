//
//  UICollectionView+Extensions.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - UICollectionView Extension

extension UICollectionView {

    func register(nibName: String, cellId: String) {
        register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: cellId)
    }

    func register(nibName: String, viewId: String) {
        register(UINib(nibName: nibName, bundle: nil),
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: viewId)
    }
}
