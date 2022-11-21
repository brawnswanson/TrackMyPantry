//
//  NestedListContent.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 08.04.22.
//

import Foundation
import CoreData

struct NestedListContent: Identifiable {
    let id = UUID()
    let description: String
    var children: [NestedListContent]? = nil
    let object: NSManagedObject
}
