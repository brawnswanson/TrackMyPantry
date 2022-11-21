//
//  EditLocationNameSheetView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 22.04.22.
//

import SwiftUI

struct EditLocationNameSheetView: View {
    
    @Environment(\.presentationMode) var isPresented
    
    private var location: StorageLocation
    @State private var name: String
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Location Name", text: $name)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: { updateLocation()
                        isPresented.wrappedValue.dismiss()
                    }, label: { Text("Save")})
                })
                ToolbarItem(placement: .navigationBarLeading, content: { Button(action: { isPresented.wrappedValue.dismiss() }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                })})
            }
            .navigationTitle("Edit Location Name")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    init(location: StorageLocation) {
        self.location = location
        _name = State(initialValue: location.name!)
    }
    
    func updateLocation() {
        var dict = [String:Any]()
        dict.updateValue(name, forKey: "name")
        CoreDataCoordinator.sharedCoreData.updateEntity(objectToUpdate: location, keyedValues: dict)
    }
}

struct EditLocationNameSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EditLocationNameSheetView(location: StorageLocation())
    }
}
