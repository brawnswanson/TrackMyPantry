//
//  InventoryMeasurement.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 07.04.22.
//

import Foundation

class InventoryMeasurement: CustomStringConvertible {
    
    private var measurement: Measurement<Dimension>
    private var dimension: Dimension?
    public var description: String {
        measurement.description
    }
    
    init(value: Double, symbol: String) {
        self.measurement = Measurement(value: value, unit: Dimension(symbol: symbol))
    }
}

extension InventoryMeasurement {
    enum UnitType {
        case grams, kilograms, ounces, pounds, liters, milliliters, cups, gallons, fluidOunces, unit, box, roll
        
        var unitCategory: UnitCategory {
            switch self {
            case .grams, .kilograms, .ounces, .pounds:
                return .mass
            case .liters, .milliliters, .cups, .gallons, .fluidOunces:
                return .volume
            case .unit, .box, .roll:
                return .count
            }
        }
    }
    
    enum UnitCategory {
        case mass, volume, count
        
        var unitsList: [Dimension] {
            switch self {
            case .mass:
                return [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds]
            case .volume:
                return [UnitVolume.liters, UnitVolume.milliliters, UnitVolume.cups, UnitVolume.gallons, UnitVolume.fluidOunces]
            case .count:
                return [CountUnit.unit, CountUnit.box, CountUnit.roll]
            }
        }
    }
}
