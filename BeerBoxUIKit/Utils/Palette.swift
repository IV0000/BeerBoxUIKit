//
//  Palette.swift
//  BeerBoxUIKit
//
//  Created by Ivan Voloshchuk on 28/02/23.
//

import UIKit

class Palette {
    static let shared: Palette = .init()

    static let backgroundColor = UIColor(hex: 0x0E181C)
    static let titleColor = UIColor(hex: 0xFFFFFF)
    static let textColor = UIColor(hex: 0x8B9193)
    static let searchBarColor = UIColor(hex: 0x1C262B)
    static let primaryColor = UIColor(hex: 0xE8B04E)
    static let darkTextColor = UIColor(hex: 0x1C1D23)
    static let bannerColor = UIColor(hex: 0xF1B24E)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}
