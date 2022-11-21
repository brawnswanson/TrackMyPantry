//
//  ItemInfo+CoreDataClass.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 26.03.22.
//
//

import Foundation
import CoreData

@objc(ItemInfo)
public class ItemInfo: NSManagedObject {

}

extension ItemInfo {
    public override var description: String {
        let nameString = name ?? ""
        let packageMeasure = InventoryMeasurement(value: packageQuantityMagnitude, symbol: packageQuantityUnits!)
        let packageString = packageMeasure.description
        return "\(nameString) pack:\(packageString)"
    }
}
