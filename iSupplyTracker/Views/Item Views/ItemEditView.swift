//
//  ItemEditView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 25.03.22.
//
//TODO: Need to add a locaiton for creating new items
//TODO: Make text fields gray?
//TODO: Need to be able to edit items

import SwiftUI

struct ItemEditView: View {
    
    @Environment(\.presentationMode) var isPresented
    
    @State private var barCode: BarCode
    @State private var item: ItemInfo?
    
    @State private var name: String
    @State private var packageQuantityMagnitude: String
    @State private var packageQuantityUnits: Dimension
    @State private var packageQuantityType: UnitTypes
    @State private var shelfLife: String
    @State private var selectedCategoryID: UUID?
    @State private var sheetNavigationTitle: String
    @State private var unitTypeDisabled = false
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(value: true)) var categories: FetchedResults<Category>
    @FetchRequest(sortDescriptors: []) var selectedCategory: FetchedResults<Category>
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFieldNavigatationView(ifEmptyLabel: "New Item", title: "Item Name", text: $name)
                }
                Section {
                    TextFieldNavigatationView(ifEmptyLabel: "Package Quantity", title:"Package Quantity", text: $packageQuantityMagnitude)
                }
                Section {
                    UnitPickerView(selection: $packageQuantityUnits, disableType: unitTypeDisabled, selectedType: $packageQuantityType)
                }
                Section {
                    Picker(selection: $selectedCategoryID, content: {
                        ForEach(categories, id:\.id) { category in
                            Text("\(category.name!)").tag(category.id!)
                        }
                    }, label: { Text("Select Category:")})
                    
                }
                Section {
                    TextFieldNavigatationView(ifEmptyLabel: "Number of months", title: "Shelf-life in months", text: $shelfLife)
                }
                Section{
                    
                    HStack {
                        Text("Barcode")
                        Spacer()
                        Text("\(barCode.code)")
                    }
                }
            }
            .onChange(of: selectedCategoryID, perform: { id in
                guard let selectedID = id else { return }
                selectedCategory.nsPredicate = NSPredicate(format: "id == %@", selectedID as CVarArg)
                guard let category = selectedCategory.first, let unit = category.minimumDesiredInventoryUnits else {
                    unitTypeDisabled = false
                    return
                }
                packageQuantityType = UnitTypes.unitType(for: UnitTypes.getDimension(for: unit))
                packageQuantityUnits = UnitTypes.unitType(for: UnitTypes.getDimension(for: unit)).baseUnit
                unitTypeDisabled = true
            })
            .navigationTitle(sheetNavigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        save()
                        isPresented.wrappedValue.dismiss() }, label: { Text("Save")}).disabled(!isSaveable)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(role: .cancel, action: { isPresented.wrappedValue.dismiss()}, label: { Text("Cancel")})
                }
            }
        }
    }
    
    init(barCode: BarCode) {
        _barCode = State(initialValue: barCode)
        _name = State(initialValue: "")
        _packageQuantityMagnitude = State(initialValue: "0.0")
        _packageQuantityUnits = State(initialValue: UnitMass.grams)
        _packageQuantityType = State(initialValue: .mass)
        _shelfLife = State(initialValue:  "12")
        _sheetNavigationTitle = State(initialValue: "New Item")
    }
    
    init(currentItem: ItemInfo) {
        _item = State(initialValue: currentItem)
        _barCode = State(initialValue: BarCode(code: currentItem.barCode!))
        _name = State(initialValue: currentItem.name!)
        _packageQuantityMagnitude = State(initialValue: String(currentItem.packageQuantityMagnitude))
        _packageQuantityUnits = State(initialValue: UnitTypes.getDimension(for: currentItem.packageQuantityUnits!))
        _packageQuantityType = State(initialValue: UnitTypes.unitType(for: UnitTypes.getDimension(for: currentItem.packageQuantityUnits!)))
        _shelfLife = State(initialValue:  String(Int(currentItem.shelfLifeInMonths)))
        _selectedCategoryID = State(initialValue: currentItem.category!.id!)
        _sheetNavigationTitle = State(initialValue: "Edit: \(currentItem.name!)")
    }
}

struct ItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ItemEditView(barCode: BarCode(code: "12"))
    }
}

extension ItemEditView {
    
    private var isSaveable: Bool {
        guard let _ = Double(packageQuantityMagnitude), let _ = selectedCategoryID, let _ = Int(shelfLife) else { return false }
        return true
    }
    
    private var keyDictionary: [String:Any] {
        var dictionary: [String:Any] = [:]
        dictionary[CreateItemInfoKeys.name.rawValue] = name
        dictionary[CreateItemInfoKeys.barCode.rawValue] = barCode.code
        dictionary[CreateItemInfoKeys.packageQuantityUnits.rawValue] = packageQuantityUnits.symbol
        dictionary[CreateItemInfoKeys.packageQuantityMagnitude.rawValue] = Double(packageQuantityMagnitude)!
        dictionary[CreateItemInfoKeys.shelfLifeInMonths.rawValue] = Double(shelfLife)!
        if let catSelected = selectedCategory.first {
            dictionary["category"] = catSelected
        }
        return dictionary
    }
        
}
    
extension ItemEditView {
    func save() {
        guard let currentItem = item else  {
            let _ = CoreDataCoordinator.sharedCoreData.createEntity(entity: ItemInfo.entity(), keyedValues: keyDictionary) as! ItemInfo
            return
        }
        CoreDataCoordinator.sharedCoreData.updateEntity(objectToUpdate: currentItem, keyedValues: keyDictionary)
    }
}
