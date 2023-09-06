//
//  BaseViewController.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - BaseViewController

class BaseViewController: UIViewController {

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBaseUI()
        setupBaseSettings()

        setupUI()
        setupSettings()
    }

    // MARK: - Setup

    private func setupBaseUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func setupBaseSettings() {}

    // MARK: Internal Methods

    func setupUI() {}
    func setupSettings() {}

    // MARK: Deinit

    deinit {
        debugPrint(String(describing: self))
    }
}
