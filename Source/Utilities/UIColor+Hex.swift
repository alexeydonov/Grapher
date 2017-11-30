//
//  UIColor+Hex.swift
//  Grapher
//
//  Created by Alexey Donov on 30/11/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex value: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat((value & 0xFF0000) >> 16) / 255.0, green: CGFloat((value & 0x00FF00) >> 8) / 255.0, blue: CGFloat(value & 0x0000FF) / 255.0, alpha: alpha)
    }
}
