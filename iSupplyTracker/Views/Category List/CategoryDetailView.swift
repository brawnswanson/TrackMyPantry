//
//  CategoryDetailList.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 23.03.22.
//TODO: Add list of items belonging to category and some indication of inventory of each item

import SwiftUI

struct CategoryDetailView: View {
    
    @State private var name: String
    @State private var minimumQuantity: String
    @State private var units: Dimension
    @State private var unitType: UnitTypes
    @State private var category: Category?
    @State private var itemToDelete: ItemInfo?
    @State private var deleteConfirmationPresented = false
    
    private var keyDictionary: [String: Any] {
        var dictionary: [String:Any] = [:]
        dictionary[CreateCategoryKeys.name.rawValue] = name
        dictionary[CreateCategoryKeys.minimumDesiredInventoryUnits.rawValue] = units.symbol
        dictionary[CreateCategoryKeys.minimumDesiredInventoryMagnitude.rawValue] = Double(minimumQuantity)!
        return dictionary
    }
    
    @FetchRequest var items: FetchedResults<ItemInfo>
    
    @Environment(\.presentationMode) var isPresented
    
    var body: some View {
        Form {
            Section {
                TextFieldNavigatationView(ifEmptyLabel: "New Category",title: "Title", text: $name)
            }
            Section {
                TextFieldNavigatationView(ifEmptyLabel: "Minimum Quantity",title: "Minimum Quantity", text: $minimumQuantity)
            }
            Section(content: {
                UnitPickerView(selection: $units, disableType: unitTypeDisabled, selectedType: $unitType)
            }, header: { Text("Package Units")})
            Section {
                List {
                    ForEach(items, id:\.id) { item in
                        Text("\(item.name!) \(packageSize(item: item))")
                    }
                    .onDelete(perform: { indexSet in
                        guard let index = indexSet.first else { return }
                        let itemToDelete = items[index]
                        self.itemToDelete = itemToDelete
                        deleteConfirmationPresented.toggle()
                    })
                }
            }
        }
        .onChange(of: unitType, perform: { type in
            units = type.baseUnit
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    self.saveCategory()
                    self.isPresented.wrappedValue.dismiss()}, label: { Text("Save") }).disabled(!isSaveable)
            })
        }
        .navigationTitle("\(category == nil ? "New Category":"Edit Category")")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Delete item?", isPresented: $deleteConfirmationPresented, actions: {
            Button(role: .destructive, action: {
                if let item = itemToDelete {
                    CoreDataCoordinator.sharedCoreData.deleteEntity(objectToDelete: item)
                }
                self.itemToDelete = nil
            }, label: { Text("Delete")})
        }, message: { Text("Deleting item will delete all lots with same barcode from inventory.")})
    }
    
    init(category: Category?) {
        _category = State(initialValue: category)
        guard let currentCategory = category else {
            _name = State(initialValue: "New Category")
            _minimumQuantity = State(initialValue: "0.0")
            _units = State(initialValue: UnitMass.grams)
            _unitType = State(initialValue: .mass)
            _items = FetchRequest(sortDescriptors: [], predicate: NSPredicate(value: false))
            return
        }
        _name = State(initialValue: currentCategory.name!)
        _minimumQuantity = State(initialValue: currentCategory.minimumDesiredInventoryMagnitude.description)
        _units = State(initialValue: UnitTypes.getDimension(for: currentCategory.minimumDesiredInventoryUnits!))
        _unitType = State(initialValue: UnitTypes.unitType(for: UnitTypes.getDimension(for: currentCategory.minimumDesiredInventoryUnits!)))
        _items = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "category == %@", currentCategory))
        
    }
}

extension CategoryDetailView {
    private var unitTypeDisabled: Bool {
        if items.count == 0 {
            return false
        }
        else {
           return true
        }
    }
    
    func packageSize(item: ItemInfo) -> String {
        let measurement = Measurement(value: item.packageQuantityMagnitude, unit: getDimension(for: item.packageQuantityUnits!))
        let formatNumber = NumberFormatter()
        formatNumber.usesSignificantDigits = true
        formatNumber.minimumSignificantDigits = 1
        formatNumber.maximumSignificantDigits = 3
        let measureFormatter = MeasurementFormatter()
        measureFormatter.numberFormatter = formatNumber
        measureFormatter.unitOptions = .providedUnit
        return measureFormatter.string(from: measurement)
    }
    
    func saveCategory() {
        if let categoryToEdit = category {
            CoreDataCoordinator.sharedCoreData.updateEntity(objectToUpdate: categoryToEdit, keyedValues: keyDictionary)
        }
        else {
            let _ = CoreDataCoordinator.sharedCoreData.createEntity(entity: Category.entity(), keyedValues: keyDictionary)
        }
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
    
    private var isSaveable: Bool {
        guard let _ = Double(minimumQuantity) else { return false}
        return true
    }
}
