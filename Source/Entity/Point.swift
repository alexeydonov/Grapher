//
//  Point.swift
//  Grapher
//
//  Created by Alexey Donov on 30/11/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import Foundation

struct Point {
    var date: Date
    var value: Double
}

extension Point: PropertyList {
    var propertyList: [String : Any] {
        return [
            "date": date,
            "value": value
        ]
    }
    
    init?(with propertyList: [String : Any]) {
        guard let d = propertyList["date"] as? Date,
            let v = propertyList["value"] as? Double else { return nil }
        
        self.init(date: d, value: v)
    }
}
