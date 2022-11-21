//
//  UnitPickerView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 23.03.22.
//

import SwiftUI

struct UnitPickerView: View {
    
    var typeDisabled: Bool
    @Binding private var selectedUnit: Dimension
    @Binding private var selectedType: UnitTypes
    
    var body: some View {
        VStack {
            Picker(selection: $selectedType, content: {
                ForEach(UnitTypes.allCases, id:\.self) { type in
                    Text("\(type.description)").tag(type)
                }
            }, label: { Text("Select unit type:")})
            .disabled(typeDisabled)
            .pickerStyle(.segmented)
            Picker(selection: $selectedUnit, content: {
                ForEach(selectedType.dimensionsList, id:\.self) { unit in
                    Text(unit.symbol).tag(unit.symbol)
                }
            }, label: { Text("Select unit:")})
            .pickerStyle(.segmented)
        }
    }
    
    init(selection: Binding<Dimension>, disableType: Bool, selectedType: Binding<UnitTypes>) {
        _selectedType = selectedType
        _selectedUnit = selection
        typeDisabled = disableType
    }
}

struct UnitPickerView_Previews: PreviewProvider {
    static var previews: some View {
        UnitPickerView(selection: .constant(UnitMass.grams), disableType: false, selectedType: .constant(.mass))
    }
}



enum UnitTypes: CaseIterable {
    case mass
    case volume
    case count
    
    var description: String {
        switch self {
        case .mass:
            return "Mass"
        case .volume:
            return "Volume"
        case .count:
            return "Count"
        }
    }
    
    var dimensionsList: [Dimension] {
        switch self {
        case .mass:
            return [UnitMass.grams, UnitMass.kilograms, UnitMass.pounds, UnitMass.ounces]
        case .volume:
            return [UnitVolume.liters, UnitVolume.milliliters, UnitVolume.gallons, UnitVolume.cups]
        case .count:
            return [CountUnit.unit, CountUnit.box, CountUnit.roll]
        }
    }
    
    var baseUnit: Dimension {
        switch self {
        case .mass:
            return UnitMass.grams
        case .volume:
            return UnitVolume.liters
        case .count:
            return CountUnit.unit
        }
    }
    
    static func unitType(for dimension: Dimension) -> UnitTypes {
        if dimension == UnitMass.grams || dimension == UnitMass.kilograms || dimension == UnitMass.pounds || dimension == UnitMass.ounces {
            return Self.mass
        }
        else if dimension == UnitVolume.liters || dimension == UnitVolume.milliliters || dimension == UnitVolume.gallons || dimension == UnitVolume.cups {
            return Self.volume
        }
        else {
            return Self.count
        }
    }
    
    static func getDimension(for symbol: String) -> Dimension {
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
