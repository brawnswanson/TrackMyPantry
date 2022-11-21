//
//  LocationsView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 08.04.22.
//

import SwiftUI

struct LocationsView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(value: true)) var locations: FetchedResults<StorageLocation>
    @FetchRequest(sortDescriptors: []) var filteredLots: FetchedResults<Lot>
    
    var body: some View {
        Form {
            Section(content: {
                List(listContent, children: \.children) { item in
                    Text("\(item.description)")
                }
            }, header: { Text("Location")})
        }
        .navigationTitle("Locations")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
    }
}

extension LocationsView {
    
    private var listContent: [NestedListContent] {
        var contentArray = [NestedListContent]()
        for location in locations {
            var locationContent = NestedListContent(description: location.description, object: location)
            if let lots = location.lots?.array as? [Lot] {
                var lotItemInfoArray = [ItemInfo]()
                for lot in lots {
                    lotItemInfoArray.append(lot.item!)
                }
                let lotItemInfoSet = Set(lotItemInfoArray)
                var itemInfoListContent = [NestedListContent]()
                for itemInfo in lotItemInfoSet {
                    var itemInfoContent = NestedListContent(description: itemInfo.description, object: itemInfo)
                    var lotListContent = [NestedListContent]()
                    filteredLots.nsPredicate = NSPredicate(format: "item == %@ AND location == %@", itemInfo, location)
                    for itemLot in filteredLots {
                        lotListContent.append(NestedListContent(description: itemLot.description, object: itemLot))
                    }
                    if lotListContent.count > 0 {
                        itemInfoContent.children = lotListContent
                    }
                    itemInfoListContent.append(itemInfoContent)
                }
                if itemInfoListContent.count > 0 {
                    locationContent.children = itemInfoListContent
                }
            }
            contentArray.append(locationContent)
        }
        return contentArray
    }
}
