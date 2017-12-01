//
//  PropertyList.swift
//  Grapher
//
//  Created by Alexey Donov on 01/12/2017.
//  Copyright © 2017 Alexey Donov. All rights reserved.
//

import Foundation

protocol PropertyList {
    var propertyList: [String : Any] { get }
    init?(with propertyList: [String : Any])
}
