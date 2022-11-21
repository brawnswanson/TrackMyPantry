//
//  Category+CoreDataClass.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 26.03.22.
//
//

import Foundation
import CoreData

@objc(Category)
public class Category: NSManagedObject {

}

extension Category {
    public override var description: String {
        let nameString = name ?? ""
        let minMeasurement = InventoryMeasurement(value: minimumDesiredInventoryMagnitude, symbol: minimumDesiredInventoryUnits!)
        let minString = minMeasurement.description
        return "\(nameString) min:\(minString)"
    }
}
