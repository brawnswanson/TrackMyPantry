//
//  AddExpiringInventoryPaneView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 11.04.22.
//

import SwiftUI

struct InventoryByDateSetupView: View {
   
    @Environment(\.presentationMode) var isPresented
    @State private var quantity = "1"
    @State private var timeUnit: TimeUnits = .years
    @State private var title: String = "New Info Pane"
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFieldNavigatationView(ifEmptyLabel: "Title", title: "", text: $title)
                }
                Section(content:
                            {
                                HStack {
                                    TextField("Quantity", text: $quantity)
                                    Spacer()
                                    Picker(selection: $timeUnit, content: {
                                        ForEach(TimeUnits.allCases, id:\.self) { unit in
                                            Text(unit.rawValue)
                                        }
                                    }, label: { })
                                    .pickerStyle(.menu)
                                }
                }, header: { Text("Duration before expiration")})
            }
            .navigationTitle("Expiring Inventory")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        save()
                        isPresented.wrappedValue.dismiss()
                    }, label: { Text("Save") })
                        .disabled(saveDisabled)
                })
            }
        }
    }
    
    func save() {
        let _ = CoreDataCoordinator.sharedCoreData.createEntity(entity: InfoPane.entity(), keyedValues: keys)
    }
}

extension InventoryByDateSetupView {
    
    var keys: [String:Any] {
        var dict = [String:Any]()
        dict.updateValue(title, forKey: ExpiringInventoryPaneKey.title.rawValue)
        dict.updateValue(InfoPaneTypes.expiringInventory.rawValue, forKey: ExpiringInventoryPaneKey.type.rawValue)
        dict.updateValue(dataKeys, forKey: ExpiringInventoryPaneKey.keys.rawValue)
        return dict
    }
    
    var dataKeys: [String : Any] {
        var dict = [String:Any]()
        dict.updateValue(quantity, forKey: InfoPaneTypes.ExpiringInventoryKeys.timeMagnitude.rawValue)
        dict.updateValue(timeUnit.rawValue, forKey: InfoPaneTypes.ExpiringInventoryKeys.timeUnit.rawValue)
        return dict
    }
    
    var saveDisabled: Bool {
        guard let _ = Double(quantity) else { return true }
        return false
    }
}
