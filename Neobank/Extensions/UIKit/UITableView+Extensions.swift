//
//  UITableView+Extensions.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - UITableView Extension

extension UITableView {

    func register(nibName: String, cellId: String) {
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: cellId)
    }

    func register(nibName: String, headerViewId: String) {
        register(UINib(nibName: nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: headerViewId)
    }
}
