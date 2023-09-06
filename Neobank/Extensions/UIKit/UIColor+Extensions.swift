//
//  UIColor+Extensions.swift
//  Neobank
//
//  Created by Konstantin Stolyarenko on 05.05.2022.
//  Copyright © 2022 SKS. All rights reserved.
//

import UIKit

// MARK: - UIColor Hex Extension

/// Extension for UIColor functionality.
public extension UIColor {

    // MARK: - Init

    /// Extends the functionality of a UIColor with the ability to init it with hex string.
    ///
    /// - Parameters:
    ///   - hexString: The String Object. The hex string to init UIColor.
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, .zero, .zero, .zero)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    // MARK: - Public Methods

    /// Extends the functionality of a UIColor with the ability to convert it to hex string.
    ///
    /// - Returns: The String Object that contains a color in hex format.
    func toHexString() -> String {
        var r: CGFloat = .zero
        var g: CGFloat = .zero
        var b: CGFloat = .zero
        var a: CGFloat = .zero
        getRed(&r, green: &g, blue: &b, alpha: &a)
        // swiftlint:disable:next custom_zero
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return String(format: "#%06x", rgb)
    }

    /// Extends the functionality of a UIColor with the ability to use color asset for all iOS Versions.
    /// iOS 13+ by name and older by base color.
    ///
    /// - Parameters:
    ///   - colorAssetName: The String Object. The name for color asset used for dark mode in iOS 13 and higher.
    ///   - baseColor: The UIColor Object. The color used as base color for iOS versions below iOS 13.
    /// - Returns: The UIColor Object.
    static func colorAsset(name colorAssetName: String, baseColor: UIColor, aboveiOS11Mock: Bool = true) -> UIColor {
        if #available(iOS 11.0, *), aboveiOS11Mock {
            return UIColor(named: colorAssetName) ?? baseColor
        } else {
            return baseColor
        }
    }
}

// MARK: - UIColor Static Color Extension

/// Extension for UIColor custom colors.
///
/// All color names are taken according to the resource: https://www.schemecolor.com/
/// In order to determine the name for the desired color in hex format use this search request:
/// https://www.schemecolor.com/sample?getcolor=202020
extension UIColor {

    // Grayscale Colors
    static let blackColor = UIColor(hexString: "000000")
    static let chineseBlackColor = UIColor(hexString: "0B111B")
    static let darkGunmetalColor = UIColor(hexString: "1C2433")
    static let gunmetalColor = UIColor(hexString: "2A303D")
    static let lightGunmetalColor = UIColor(hexString: "2B313A")
    static let philippineSilverColor = UIColor(hexString: "AAAFB8")
    static let ghostWhiteColor = UIColor(hexString: "F7FAFF")
    static let lightCulturedWhiteColor = UIColor(hexString: "F5F7FA")
    static let whiteColor = UIColor(hexString: "ffffff")

    // Red Colors

    // Green Colors
    static let ufoGreenColor = UIColor(hexString: "29CC7C")
    static let mediumAquamarine = UIColor(hexString: "69F0AE")

    // Blue Colors
    static let crayolaPeriwinkleColor = UIColor(hexString: "C3CFE2")

    // Orange Colors
    static let fleshColor = UIColor(hexString: "FFECD2")
    static let deepPeachColor = UIColor(hexString: "FCB69F")

    // MARK: - TODO: Refactor Colors

    internal static let grDarkBlackColor = UIColor(red: 0.09, green: 0.08, blue: 0.11, alpha: 1.00)
    internal static let grLightBlackColor = UIColor(red: 0.20, green: 0.22, blue: 0.24, alpha: 1.00)

    internal static let grDarkGrayColor = UIColor(red: 0.34, green: 0.36, blue: 0.41, alpha: 1.00)
    internal static let grLightGrayColor = UIColor(red: 0.58, green: 0.60, blue: 0.71, alpha: 1.00)

    internal static let awardsLightGreyColor = UIColor(red: 0.22, green: 0.23, blue: 0.25, alpha: 1.00)
    internal static let awardsGreyColor = UIColor(red: 0.13, green: 0.14, blue: 0.16, alpha: 1.00)
    internal static let awardsGreenColor = UIColor(red: 0.30, green: 0.64, blue: 0.31, alpha: 1.00)

    internal static let tabBarRedColor = UIColor(red: 0.91, green: 0.37, blue: 0.36, alpha: 1.00)
    internal static let tabBarGreyColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1.00)
    internal static let tabBarLightGrayColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
}

// MARK: - UIColor Between Color Extension

extension UIColor {

    static func colorBetween(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = .zero
        var fromGreen: CGFloat = .zero
        var fromBlue: CGFloat = .zero
        var fromAlpha: CGFloat = .zero

        // Get the RGBA values from the fromColor
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)

        var toRed: CGFloat = .zero
        var toGreen: CGFloat = .zero
        var toBlue: CGFloat = .zero
        var toAlpha: CGFloat = .zero

        // Get the RGBA values from the toColor
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)

        // Calculate the actual RGBA values of the fade colour
        let red = (toRed - fromRed) * percent + fromRed
        let green = (toGreen - fromGreen) * percent + fromGreen
        let blue = (toBlue - fromBlue) * percent + fromBlue
        let alpha = (toAlpha - fromAlpha) * percent + fromAlpha

        // Return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
