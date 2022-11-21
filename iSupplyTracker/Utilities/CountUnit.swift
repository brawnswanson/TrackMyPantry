//
//  CountUnit.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 07.04.22.
//

import Foundation

class CountUnit: Dimension {
    static let unit = CountUnit(symbol: "unit", converter: UnitConverterLinear(coefficient: 1.0))
    static let roll = CountUnit(symbol: "roll", converter: UnitConverterLinear(coefficient: 1.0))
    static let box = CountUnit(symbol: "box", converter: UnitConverterLinear(coefficient: 1.0))
    
    override static func baseUnit() -> Self {
        CountUnit.unit as! Self
    }
}
