//
//  Lot+CoreDataProperties.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 31.03.22.
//
//

import Foundation
import CoreData


extension Lot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lot> {
        return NSFetchRequest<Lot>(entityName: "Lot")
    }

    @NSManaged public var dateScanned: Date?
    @NSManaged public var expirationDate: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var item: ItemInfo?
    @NSManaged public var location: StorageLocation?

}

extension Lot : Identifiable {

}
