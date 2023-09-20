//
//  CardDetailViewModel.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - CardDetail ViewModel

struct CardDetailViewModel {

    // MARK: - Internal Properties

    var title: String
    var subtitle: String?
    var image: UIImage
}

// MARK: - CardDetail Mock Extension

extension CardDetailViewModel {

    static func mock(title: String = "Apple Pay",
                     subtitle: String? = "Card added",
                     image: UIImage = UIImage.CardDetailViewModel.applePayImage) -> Self {
        .init(title: title,
              subtitle: subtitle,
              image: image)
    }
}
