//
//  ValueGraphView.swift
//  Grapher
//
//  Created by Alexey Donov on 30/11/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import UIKit

class ValueGraphView: UIView {
    
    var low: Double = 0
    var high: Double = 100
    
    var values: [Double] = [] {
        didSet {
            low = values.min() ?? 0
            high = values.max() ?? 100
            setNeedsDisplay()
        }
    }
    
    var graphColor: UIColor = .black

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
