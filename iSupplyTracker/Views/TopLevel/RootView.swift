//
//  RootView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 22.03.22.
//
//IMP: Reminders for updating inventory at different locations
//IMP: Inventory calculation code can be consolidated and update more elegantly. Currently emptying and reload predicate on appear to trick data into reloading
//TODO: THink i need to add an environment observable object for things like inventory calculation, measurement conversion. They are used repeatedly and doesn't make sense to make a view file for these calculations
//TODO: New item screen needs a header on item name
//TODO: Make scanner overlays look nicer
//TODO: Add uncategorized option
//TODO: Need better description options, customizable
//TODO: Move all measurement code out of views
//TODO: Move locations editing to the settings page
//TODO: Change scanner view location symbol to the compass arrow thing
import SwiftUI

struct RootView: View {
    
    var body: some View {
        TabView {
            NavigationView { SummaryView() }.customTabItem(tabImage: "chart.pie.fill", label: "Summary")
            NavigationView { CategoriesListView() }.customTabItem(tabImage: "list.bullet", label: "Categories")
            NavigationView { LocationsView() }.customTabItem(tabImage: "house.fill", label: "Locations")
            NavigationView { ScannerView() }.customTabItem(tabImage: "barcode.viewfinder", label: "Scan")
            NavigationView { InventoryListView() }.customTabItem(tabImage: "archivebox.fill", label: "Inventory")
        }
        .navigationViewStyle(.stack)
        .background(.black)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}


