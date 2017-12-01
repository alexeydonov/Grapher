//
//  Graph.swift
//  Grapher
//
//  Created by Alexey Donov on 30/11/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import Foundation

struct Graph {
    var name: String
    var color: Float
    var points: [Point]
    var threshold: Int?
}

extension Graph: PropertyList {
    var propertyList: [String : Any] {
        var result: [String : Any] = [
            "name": name,
            "color": color,
            "points": points.map { $0.propertyList }
        ]
        if let t = threshold {
            result["threshold"] = t
        }
        
        return result
    }
    
    init?(with propertyList: [String : Any]) {
        guard let n = propertyList["name"] as? String,
            let c = propertyList["color"] as? Float,
            let p = propertyList["points"] as? [[String : Any]] else { return nil }
        let t = propertyList["threshold"] as? Int
        let ps = p.flatMap(Point.init(with:))
        
        self.init(name: n, color: c, points: ps, threshold: t)
    }
}
