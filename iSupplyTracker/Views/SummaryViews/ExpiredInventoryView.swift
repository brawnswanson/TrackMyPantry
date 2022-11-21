//
//  ExpiredInventoryView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 08.04.22.
//
//TODO: Change name of this file and class to represent that it's not just expired stuff

import SwiftUI

struct ExpiredInventoryView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest private var expiredLots: FetchedResults<Lot>
    
    var body: some View {
        VStack {
            ForEach(expiredLots, id:\.id) { lot in
                    Text("\(lot.item!.description): \(lot.description) in \(lot.location?.description ?? "No Location")")
            }
        }
    }
    
    init(info: [String:Any]) {
        let timeMagnitude = Int(info[InfoPaneTypes.ExpiringInventoryKeys.timeMagnitude.rawValue] as! String)!
        let timeUnit = TimeUnits(rawValue: info[InfoPaneTypes.ExpiringInventoryKeys.timeUnit.rawValue] as! String)!
        let secondsOffSet = timeMagnitude * timeUnit.conversion
        let dateComparator = Date(timeIntervalSinceNow: Double(secondsOffSet))
        _expiredLots = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "expirationDate < %@", dateComparator as CVarArg), animation: .easeIn)
    }
}

struct ExpiredInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExpiredInventoryView(info: ["hello":1])
    }
}

enum ExpiringInventoryPaneKey: String {
    case title
    case type
    case keys
}
