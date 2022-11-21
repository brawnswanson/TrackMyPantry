//
//  SummedInventoryMeasurementView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 28.03.22.
//

import SwiftUI

struct SummedInventoryMeasurementView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) private var items: FetchedResults<ItemInfo>
    @FetchRequest(sortDescriptors: []) private var lots: FetchedResults<Lot>
    
    @Binding var category: Category
    
    var body: some View {
        Text(calculateCurrentInventory())
            .onAppear(perform: {items.nsPredicate = NSPredicate(format: "category == %@", category)})
    }
    
    func calculateCurrentInventory() -> String {
        var runningTotal = Measurement(value: 0.0, unit: getDimension(for: category.minimumDesiredInventoryUnits!))
        for item in items {
            lots.nsPredicate = NSPredicate(format: "item == %@", item)
            let lotMeasurement = Measurement(value: item.packageQuantityMagnitude, unit: getDimension(for: item.packageQuantityUnits!))
            runningTotal = runningTotal + (lotMeasurement * Double(lots.count))
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
}

struct SummedInventoryMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        SummedInventoryMeasurementView(category: .constant(Category()))
    }
}
