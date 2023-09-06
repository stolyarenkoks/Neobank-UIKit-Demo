//
//  AwardModel.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - Award Model

struct Award {

    // MARK: - Internal Properties

    let title: String
    let description: String?
    let image: UIImage?
    let isAchived: Bool

    // MARK: - Init Methods

    init(title: String, description: String?, image: UIImage? = nil, isAchived: Bool) {
        self.title = title
        self.description = description
        self.image = image
        self.isAchived = isAchived
    }
}

// MARK: - Award Mock Extension

extension Award {

    static func mock(title: String = "Попутчик",
                     description: String? = nil,
                     image: UIImage? = nil,
                     isAchived: Bool = false) -> Self {
        .init(title: title,
              description: description,
              image: image,
              isAchived: isAchived)
    }
}
