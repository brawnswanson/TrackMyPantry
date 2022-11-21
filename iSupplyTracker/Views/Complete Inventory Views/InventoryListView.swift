//
//  InventoryListView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 27.03.22.
//

import SwiftUI

struct InventoryListView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [SortDescriptor(\Lot.expirationDate, order: .forward)], predicate: NSPredicate(value: true)) private var lots: FetchedResults<Lot>
    
    @State private var sortBy: InventorySortOption = .expDate
    @State private var sortOrder: SortOrder = .forward
    
    var body: some View {
        List {
            ForEach(lots, id:\.id) { lot in
                Text("\(getLotName(lot: lot)) \(getLotSize(lot: lot)) \(getLotLocation(lot: lot)) \(getLotDate(lot: lot))")
            }
            .onDelete(perform: { indexSet in
                guard let index = indexSet.first else { return }
                let lotToDelete = lots[index]
                CoreDataCoordinator.sharedCoreData.deleteEntity(objectToDelete: lotToDelete)
            })
            
        }
        .onChange(of: sortBy, perform: { _ in
            updateSort()
        })
        .onChange(of: sortOrder, perform: { _ in
            updateSort()
        })
        .navigationTitle("Complete inventory")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                MenuPicker(sortBy: $sortBy, sortOrder: $sortOrder)
            }
        }
    }
    
    func updateSort() {
        lots.nsPredicate = NSPredicate(value: true)
        if sortBy == .expDate {
            lots.sortDescriptors =  [SortDescriptor(\Lot.expirationDate, order: sortOrder)]
        }
        else {
            lots.sortDescriptors = [SortDescriptor(sortBy.keyPathString, order: sortOrder)]
        }
//
    }
    
    func getLotDate(lot: Lot) -> String {
        guard let date = lot.expirationDate else { return "No date" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func getLotLocation(lot: Lot) -> String {
        guard let location = lot.location, let name = location.name else { return "No location" }
        return name
    }
    
    func getLotName(lot: Lot) -> String {
        guard let item = lot.item, let name = item.name else { return "No Name" }
        return name
    }
    
    func getLotSize(lot: Lot) -> String {
        guard let item = lot.item, let unit = item.packageQuantityUnits else { return "No Measure" }
        let measurement = Measurement(value: item.packageQuantityMagnitude, unit: getDimension(for: unit))
        let formatNumber = NumberFormatter()
        formatNumber.usesSignificantDigits = true
        formatNumber.minimumSignificantDigits = 1
        formatNumber.maximumSignificantDigits = 3
        let measureFormatter = MeasurementFormatter()
        measureFormatter.numberFormatter = formatNumber
        measureFormatter.unitOptions = .providedUnit
        return measureFormatter.string(from: measurement)
    }
    
    func getDimension(for symbol: String) -> Dimension {
        let massArray: [UnitMass] = [.grams, .kilograms, .pounds, .ounces]
        let volumeArray: [UnitVolume] = [.liters, .milliliters, .gallons, .cups]
        let countArray: [CountUnit] = [.unit, .box, .roll]
        if let isMass = massArray.first(where: { unitMass in
            unitMass.symbol == symbol
        }) { return isMass }
        else if let isVolume = volumeArray.first(where: { unitVolume in
            unitVolume.symbol == symbol
        }) { return isVolume }
        else if let isCount = countArray.first(where: { countUnit in
            countUnit.symbol == symbol
        }) { return isCount }
        else { return UnitMass.grams }
    }
}

struct InventoryListView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryListView()
    }
}

struct MenuPicker: View {
    
    @Binding var sortBy: InventorySortOption
    @Binding var sortOrder: SortOrder
    
    var body: some View {
        Menu(content: {
            Menu(content: {
                Picker(selection: $sortBy, content: {
                    ForEach(InventorySortOption.allCases, id:\.self) { sort in
                        Text("\(sort.rawValue)")
                    }
                }, label: {})
                Picker(selection: $sortOrder, content: {
                    Text("\(sortBy.forwardDescription)").tag(SortOrder.forward)
                    Text("\(sortBy.reverseDescription)").tag(SortOrder.reverse)
                }, label: {})
            }, label: { Text("Sort by: \(sortBy.rawValue)")})
        }, label: {Image(systemName: "ellipsis.circle") })
    }
}

enum InventorySortOption: String, CaseIterable {
    case expDate = "Expiration"
    case location = "Location"
    case name = "Name"
    case category = "Category"
    
    var keyPathString: KeyPath<Lot, String> {
        switch self {
        case .location:
            return \Lot.location!.name!
        case .name:
            return \Lot.item!.name!
        case .category:
            return \Lot.item!.category!.name!
        default:
            return \Lot.item!.name!
        }
    }

    var forwardDescription: String {
        switch self {
        case .location:
            return "A to Z"
        case .name:
            return "A to Z"
        case .category:
            return "A to Z"
        case .expDate:
            return "Expiring soonest"
        }
    }
    
    var reverseDescription: String {
        switch self {
        case .location:
            return "Z to A"
        case .name:
            return "Z to A"
        case .category:
            return "Z to A"
        case .expDate:
            return "Expiring latest"
        }
    }
    
}
