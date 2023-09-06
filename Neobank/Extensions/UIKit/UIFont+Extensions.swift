//
//  UIFont+Extensions.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - TODO: Replace Font

// MARK: - Font Extension

extension UIFont {

    /// The enumerated list of font families.
    enum FontFamily: String {
        case poppins = "Poppins"
    }

    /// The enumerated list of font weights.
    enum FontWeight: String {
        case thin = "Thin"
        case light = "Light"
        case regular = "Regular"
        case medium = "Medium"
        case bold = "Bold"
        case black = "Black"
    }

    /// Creates UIFont instance using custom font families.
    ///
    /// - Parameters:
    ///  - family: The family of custom font with type FontFamily.
    ///  - weight: The weight of custom font with type FontFamily.
    ///  - size: The size of custom font with type CGFloat.
    /// - Returns: Custom font with specified parameters with type UIFont.
    static func font(_ family: FontFamily, weight: FontWeight, size: CGFloat) -> UIFont {
        let fontName = "\(family.rawValue)-\(weight.rawValue)"
        guard let font = UIFont(name: fontName, size: size) else {
            fatalError("Font Missing! \"\(fontName)\" of size \(size) not found.")
        }
        return font
    }

    /// Make UIFont instance with style Italic.
    var italic: UIFont {
        var symbolicTraits = fontDescriptor.symbolicTraits
        symbolicTraits.insert([.traitItalic])
        let fontDescriptor = fontDescriptor.withSymbolicTraits(symbolicTraits) ?? UIFontDescriptor()
        return UIFont(descriptor: fontDescriptor, size: .zero)
    }
}

// MARK: - Font Helper Extension

extension UIFont {

    // MARK: - Poppins

    static func poppins(_ weight: FontWeight, size: CGFloat) -> UIFont {
        return font(.poppins, weight: weight, size: size)
    }
}
