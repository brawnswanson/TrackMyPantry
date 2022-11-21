//
//  Lot+CoreDataClass.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 31.03.22.
//
//

import Foundation
import CoreData

@objc(Lot)
public class Lot: NSManagedObject {

}

extension Lot {
    public override var description: String {
        let expDateString = expirationDate!.formatted(date: .abbreviated, time: .omitted)
        let scanDateString = dateScanned!.formatted(date: .abbreviated, time: .omitted)
        return "scanned:\(scanDateString), exp:\(expDateString)"
    }
}
