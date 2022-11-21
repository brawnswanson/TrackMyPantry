//
//  EditLocationsView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 21.04.22.
//

import SwiftUI

struct EditLocationsView: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var isPresented
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(value: true)) private var locations: FetchedResults<StorageLocation>
    @State private var locationToEdit: StorageLocation? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(content: {
                    List {
                        ForEach(locations, id:\.id) { location in
                            Text(location.name!)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive, action: { delete(location: location)}, label: { Image(systemName: "trash")})
                                    Button(role: .none, action: { self.locationToEdit = location }, label: { Image(systemName: "pencil")}).tint(.yellow)
                                }
                        }
                    }
                }, header: {
                    HStack {
                        Text("Locations")
                    }
                })
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: { addLocation() }, label: {Image(systemName: "plus")})
                })
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button(action: { isPresented.wrappedValue.dismiss() }, label: { HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }})
                })
            }
            .navigationTitle("Locations")
            .sheet(item: $locationToEdit, content: { location in
                EditLocationNameSheetView(location: location)
            })
        }
    }
}

struct EditLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        EditLocationsView()
    }
}

extension EditLocationsView {
    func delete(location: StorageLocation) {
        CoreDataCoordinator.sharedCoreData.deleteEntity(objectToDelete: location)
    }
    func addLocation() {
        var keys = [String:Any]()
        keys.updateValue("New Location", forKey: StorageLocation.AccessibleKeys.name.rawValue)
        let _ = CoreDataCoordinator.sharedCoreData.createEntity(entity: StorageLocation.entity(), keyedValues: keys)
    }
}

struct LocationTitleEdit: View {
    
    @State private var name: String
    
    var body: some View {
        TextField("Location Name", text: $name)
    }
    
    init(location: StorageLocation) {
        _name = State(initialValue: location.name!)
    }
}
