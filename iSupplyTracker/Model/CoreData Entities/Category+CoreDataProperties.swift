//
//  Category+CoreDataProperties.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 26.03.22.
//
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var minimumDesiredInventoryMagnitude: Double
    @NSManaged public var minimumDesiredInventoryUnits: String?
    @NSManaged public var name: String?
    @NSManaged public var items: NSOrderedSet?

}

// MARK: Generated accessors for items
extension Category {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ItemInfo)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ItemInfo)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension Category : Identifiable {

}
