//
//  SummaryView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 31.03.22.
//
//TODO: Don't like the swipe actions. Add edit mode or some better way to delete infopanes

import SwiftUI

struct SummaryView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(value: true), animation: .easeIn) private var panes: FetchedResults<InfoPane>
    
    @State private var isAddExpInvViewPresented = false
    @State private var addInfoPaneType: InfoPaneTypes? = nil
    @State private var settingsView: SettingsViewTypes? = nil
    
    var body: some View {
        Form {
            ForEach(panes, id:\.id) { pane in
                Section(content: {
                    getInfoPane(for: pane)
                }, header: { Text("\(pane.title ?? "Info Pane")")})
                .swipeActions {
                    Button(action: {
                        CoreDataCoordinator.sharedCoreData.deleteEntity(objectToDelete: pane)
                    }, label: {Text("Del")})
                }
            }
        }
        .navigationTitle("iSupplyTracker")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Menu(content: {
                    Menu("Add info pane") {
                        ForEach(InfoPaneTypes.allCases, id:\.self) { type in
                            Button(action: { addInfoPaneType = type }, label: { Text("\(type.description)")})
                        }
                    }
                    Menu("App Settings") {
                        Button(action: {settingsView = .locations}, label: { Text("Edit locations")})
                        Text("Default Units")
                    }
                }, label: { Image(systemName: "ellipsis.circle")})
            })
        }
        .sheet(item: $addInfoPaneType, content: { type in
            switch type {
            case .expiringInventory:
                InventoryByDateSetupView()
            case .inventoryBelowThreshold:
                InventoryByThresholdSetupView()
            }
        })
        .sheet(item: $settingsView, content: { type in
            switch type {
            case .locations:
                EditLocationsView()
            case .units:
                Text("Units")
            }
        })
        
    }
    
    @ViewBuilder
    func getInfoPane(for infoPane: InfoPane) -> some View {
        if let typeString = infoPane.type, let paneType = InfoPaneTypes(rawValue: typeString) {
            switch paneType {
            case .expiringInventory:
                ExpiredInventoryView(info: infoPane.keys!)
            case .inventoryBelowThreshold:
                Text("threshold")
            }
        }
        else {
            EmptyView()
        }
    }
        
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}

enum InfoPaneTypes: String, CaseIterable, CustomStringConvertible, Identifiable {
    var id: Self {
        self
    }
    
    case expiringInventory
    case inventoryBelowThreshold
    
    var description: String {
        switch self {
        case .expiringInventory:
            return "Inventory Expiring by Date"
        case .inventoryBelowThreshold:
            return "Inventory Quantities"
        }
    }
    
    var keys: [InfoPaneKeys] {
        switch self {
        case .inventoryBelowThreshold:
            return [InventoryThresholdKeys.thresholdMagnitude, InventoryThresholdKeys.thresholdUnits]
        case .expiringInventory:
            return [ExpiringInventoryKeys.timeMagnitude, ExpiringInventoryKeys.timeUnit]
        }
    }
    
    enum ExpiringInventoryKeys: String, CaseIterable, InfoPaneKeys {
        case timeMagnitude
        case timeUnit
    }
    
    enum InventoryThresholdKeys: String, CaseIterable, InfoPaneKeys {
        case thresholdMagnitude
        case thresholdUnits
    }
}

enum TimeUnits: String, CaseIterable {
    case seconds, minutes, hours, days, weeks, months, years
    
    var conversion: Int {
        switch self {
        case .seconds:
            return 1
        case .minutes:
            return 60
        case .hours:
            return 60 * 60
        case .days:
            return 60 * 60 * 24
        case .weeks:
            return 60 * 60 * 24 * 7
        case .months:
            return 60 * 60 * 24 * 30
        case .years:
            return 60 * 60 * 24 * 365
        }
    }
}

protocol InfoPaneKeys {}

enum SettingsViewTypes: String, CaseIterable, Identifiable {
    var id: Self {
        self
    }
    case locations, units
}
