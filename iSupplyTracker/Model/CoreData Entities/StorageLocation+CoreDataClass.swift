//
//  StorageLocation+CoreDataClass.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 31.03.22.
//
//

import Foundation
import CoreData

@objc(StorageLocation)
public class StorageLocation: NSManagedObject {

}

extension StorageLocation {
    public override var description: String {
        return name ?? ""
    }
    enum AccessibleKeys: String, CaseIterable {
        case name
    }
}
