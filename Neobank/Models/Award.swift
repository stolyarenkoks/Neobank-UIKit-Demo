//
//  Award.swift
//  Stablebank
//
//  Created by Konstantin Stolyarenko on 21.09.2021.
//  Copyright © 2021 CodeIT. All rights reserved.
//

import UIKit

// MARK: - Award Model

struct Award {

  // MARK: - Internal Properties

  internal let awardTitle: String
  internal let awardDescription: String
  internal let awardImage: UIImage?
  internal let isAchived: Bool

  // MARK: - Init Methods

  init(awardTitle: String, awardDescription: String, awardImage: UIImage? = nil, isAchived: Bool) {
    self.awardTitle = awardTitle
    self.awardDescription = awardDescription
    self.awardImage = awardImage
    self.isAchived = isAchived
  }
}
