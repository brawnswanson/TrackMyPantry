//
//  InfoPane+CoreDataProperties.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 12.04.22.
//
//

import Foundation
import CoreData


extension InfoPane {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InfoPane> {
        return NSFetchRequest<InfoPane>(entityName: "InfoPane")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var keys: [String:Any]?

}

extension InfoPane : Identifiable {

}
