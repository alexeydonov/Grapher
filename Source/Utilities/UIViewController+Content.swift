//
//  UIViewController+Content.swift
//  Grapher
//
//  Created by Alexey Donov on 01/12/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import UIKit

extension UIViewController {
    var contentViewController: UIViewController? {
        if let nc = self as? UINavigationController {
            return nc.visibleViewController
        }
        else {
            return self
        }
    }
}
