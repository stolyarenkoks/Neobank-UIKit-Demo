//
//  TabBarController.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - TabBarController

class TabBarController: UITabBarController {

    // MARK: - ViewController Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupSettings()
    }

    // MARK: - Setup

    private func setupUI() {
        tabBar.tintColor = .tabBarRedColor
        tabBar.backgroundColor = .tabBarLightGrayColor
        tabBar.backgroundImage = UIImage()
        tabBar.unselectedItemTintColor = .tabBarGreyColor
    }

    private func setupSettings() {
        let cardsPageViewController = Storyboard.card.instantiateVC(CardsPageViewController.self)
        let creditsViewController = Storyboard.demo.instantiateVC(DemoViewController.self)
        let profileViewController = Storyboard.demo.instantiateVC(DemoViewController.self)

        cardsPageViewController.tabBarItem = UITabBarItem(title: Const.TabBar.cardItemTitle,
                                                          image: UIImage(systemName: "creditcard"),
                                                          selectedImage: UIImage(systemName: "creditcard.fill"))
        creditsViewController.tabBarItem = UITabBarItem(title: Const.TabBar.creditsItemTitle,
                                                        image: UIImage(systemName: "chart.pie"),
                                                        selectedImage: UIImage(systemName: "chart.pie.fill"))
        profileViewController.tabBarItem = UITabBarItem(title: Const.TabBar.profileItemTitle,
                                                        image: UIImage(systemName: "person.crop.circle"),
                                                        selectedImage: UIImage(systemName: "person.crop.circle.fill"))

        viewControllers = [
            cardsPageViewController,
            creditsViewController,
            profileViewController
        ]
    }
}
