//
//  LocationSelectionView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 03.04.22.
//

import SwiftUI

struct LocationSelectionView: View {
    
    @Binding var selectedLocation: StorageLocation?
    
    @Environment(\.presentationMode) private var isPresented
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(value: true), animation: .easeIn) private var locations: FetchedResults<StorageLocation>
    
    @State private var newLocationName = ""
    
    var body: some View {
        Form {
            Section(content: {
                List {
                    ForEach(locations, id: \.id) { location in
                        HStack {
                            Button(action: {
                                selectedLocation = location
                                isPresented.wrappedValue.dismiss()
                            }, label: { Text(location.name!)})
                            Spacer()
                            if selectedLocation == location { Image(systemName: "checkmark")}
                        }
                    }
                    HStack {
                        Button(action: {
                            selectedLocation = nil
                            isPresented.wrappedValue.dismiss()
                        }, label: { Text("No location")})
                        Spacer()
                        if selectedLocation == nil { Image(systemName: "checkmark")}
                    }
                }
            }, header: { Text("Select location")})
            Section(content: {
                TextField("", text: $newLocationName, prompt: Text("Enter new location name"))
            }, header: {
                HStack {
                    Text("Add location")
                    Spacer()
                    Button(action: { addNewLocation() }, label: {Image(systemName: "plus")})
                }
            })
        }
    }
    
    func addNewLocation() {
        guard newLocationName != "" else {return}
        let _ = CoreDataCoordinator.sharedCoreData.createEntity(entity: StorageLocation.entity(), keyedValues: ["name":newLocationName])
        newLocationName = ""
    }
}

struct LocationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelectionView(selectedLocation: .constant(nil))
    }
}
