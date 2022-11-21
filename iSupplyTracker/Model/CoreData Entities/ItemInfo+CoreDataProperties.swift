//
//  ItemInfo+CoreDataProperties.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 26.03.22.
//
//

import Foundation
import CoreData


extension ItemInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemInfo> {
        return NSFetchRequest<ItemInfo>(entityName: "ItemInfo")
    }

    @NSManaged public var barCode: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var packageQuantityMagnitude: Double
    @NSManaged public var packageQuantityUnits: String?
    @NSManaged public var shelfLifeInMonths: Double
    @NSManaged public var category: Category?
    @NSManaged public var lots: NSOrderedSet?

}

// MARK: Generated accessors for lots
extension ItemInfo {

    @objc(addLotsObject:)
    @NSManaged public func addToLots(_ value: Lot)

    @objc(removeLotsObject:)
    @NSManaged public func removeFromLots(_ value: Lot)

    @objc(addLots:)
    @NSManaged public func addToLots(_ values: NSSet)

    @objc(removeLots:)
    @NSManaged public func removeFromLots(_ values: NSSet)

}

extension ItemInfo : Identifiable {

}
