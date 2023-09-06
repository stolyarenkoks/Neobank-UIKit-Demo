//
//  SegmentViewModel.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - Segment ViewModel

struct SegmentViewModel {

    // MARK: - Internal Properties

    let title: String?
    let image: UIImage?
}

// MARK: - Segment Mock Extension

extension SegmentViewModel {

    static func mock(title: String? = "Cards",
                     image: UIImage? = nil) -> Self {
        .init(title: title,
              image: image)
    }
}
