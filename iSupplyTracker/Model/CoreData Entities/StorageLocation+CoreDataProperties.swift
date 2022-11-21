//
//  StorageLocation+CoreDataProperties.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 31.03.22.
//
//

import Foundation
import CoreData


extension StorageLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StorageLocation> {
        return NSFetchRequest<StorageLocation>(entityName: "StorageLocation")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var lots: NSOrderedSet?

}

// MARK: Generated accessors for lots
extension StorageLocation {

    @objc(insertObject:inLotsAtIndex:)
    @NSManaged public func insertIntoLots(_ value: Lot, at idx: Int)

    @objc(removeObjectFromLotsAtIndex:)
    @NSManaged public func removeFromLots(at idx: Int)

    @objc(insertLots:atIndexes:)
    @NSManaged public func insertIntoLots(_ values: [Lot], at indexes: NSIndexSet)

    @objc(removeLotsAtIndexes:)
    @NSManaged public func removeFromLots(at indexes: NSIndexSet)

    @objc(replaceObjectInLotsAtIndex:withObject:)
    @NSManaged public func replaceLots(at idx: Int, with value: Lot)

    @objc(replaceLotsAtIndexes:withLots:)
    @NSManaged public func replaceLots(at indexes: NSIndexSet, with values: [Lot])

    @objc(addLotsObject:)
    @NSManaged public func addToLots(_ value: Lot)

    @objc(removeLotsObject:)
    @NSManaged public func removeFromLots(_ value: Lot)

    @objc(addLots:)
    @NSManaged public func addToLots(_ values: NSOrderedSet)

    @objc(removeLots:)
    @NSManaged public func removeFromLots(_ values: NSOrderedSet)

}

extension StorageLocation : Identifiable {

}
