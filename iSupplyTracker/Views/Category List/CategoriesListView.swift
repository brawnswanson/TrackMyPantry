//
//  CategoriesListView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 22.03.22.
//

import SwiftUI

struct CategoriesListView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) private var categories: FetchedResults<Category>
    
    @State private var categoryDetailPresented = false
    @State private var selectedCategory: Category? = nil
    @State private var confirmDeletePresented = false
    
    private var listItemWidths = [0.44, 0.28, 0.28]
    
    var body: some View {
        Form {
            Section(content: {
                List {
                    ForEach(categories, id: \.id) { category in
                        NavigationLink(destination: {
                            CategoryDetailView(category: category)
                        }, label: {
                            HStack {
                                Text("\(category.name!)")
                                Text("\(currentInventoryString(category:category))")
                                Text("\(minimumInventoryString(category:category))")
                            }
                        })
                    }
                }
            } , header: {
                HStack {
                    Text("Name")
                    Text("In Stock")
                    Text("Minimum")
                }
            })
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { categoryDetailPresented.toggle() }, label: { Image(systemName: "plus") })
            }
        }
        .sheet(isPresented: $categoryDetailPresented, content: { NavigationView {
            CategoryDetailView(category: nil)
        }})
        .sheet(item: $selectedCategory, onDismiss: { selectedCategory = nil }, content: { category in
            NavigationView {
                CategoryDetailView(category: category)
            }
        })
        .onAppear(perform: {
            categories.nsPredicate = NSPredicate(value: false)
            categories.nsPredicate = NSPredicate(value: true)})
    }
}

struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView()
    }
}

extension CategoriesListView {
    func minimumInventoryString(category: Category) -> String {
        guard let units = category.minimumDesiredInventoryUnits else { return "Err"}
//        let returnMeasurement = Measurement<Dimension>(value: category.minimumDesiredInventoryMagnitude, unit: UnitMass(symbol: units))
        let returnMeasurement = Measurement(value: category.minimumDesiredInventoryMagnitude, unit: getDimension(for: units))
        let formatNumber = NumberFormatter()
        formatNumber.usesSignificantDigits = true
        formatNumber.minimumSignificantDigits = 1
        formatNumber.maximumSignificantDigits = 3
        let measureFormatter = MeasurementFormatter()
        measureFormatter.numberFormatter = formatNumber
        measureFormatter.unitOptions = .providedUnit
        return measureFormatter.string(from: returnMeasurement)
    }
    
    func currentInventoryString(category: Category) -> String {
        guard let items = category.items?.array as? [ItemInfo] else {return "Err"}
        var runningTotal = Measurement(value: 0.0, unit: getDimension(for: category.minimumDesiredInventoryUnits!))
        for item in items {
            if let lots = item.lots?.array as? [Lot] {
                let lotMeasurement = Measurement(value: item.packageQuantityMagnitude, unit: getDimension(for: item.packageQuantityUnits!))
                runningTotal = runningTotal + (lotMeasurement * Double(lots.count))
            }
        }
        let returnMeasurement = runningTotal.converted(to: getDimension(for: category.minimumDesiredInventoryUnits!))
        let formatNumber = NumberFormatter()
        formatNumber.usesSignificantDigits = true
        formatNumber.minimumSignificantDigits = 1
        formatNumber.maximumSignificantDigits = 3
        let measureFormatter = MeasurementFormatter()
        measureFormatter.numberFormatter = formatNumber
        measureFormatter.unitOptions = .providedUnit
        return measureFormatter.string(from: returnMeasurement)
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
    
    func categoryName(category: Category) -> String {
        return category.name ?? "Name Err"
    }
    
    func headerValuesFor(category: Category) -> [(String,Double)] {
        var result: [(String,Double)] = []
        result.append((categoryName(category: category), listItemWidths[0]))
        result.append((currentInventoryString(category: category), listItemWidths[1]))
        result.append((minimumInventoryString(category: category), listItemWidths[2]))
        return result
    }
    
    func headerValuesForHeader() -> [(String, Double)] {
        var result: [(String, Double)] = []
        result.append(("Name", listItemWidths[0]))
        result.append(("In Stock", listItemWidths[1]))
        result.append(("Minimum", listItemWidths[2]))
        return result
    }
}
