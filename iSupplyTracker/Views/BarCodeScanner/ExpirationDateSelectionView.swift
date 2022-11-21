//
//  ExpirationDateSelectionView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 04.04.22.
//

import SwiftUI

struct ExpirationDateSelectionView: View {
    
    @Environment(\.presentationMode) var isPresented
    @Binding var expDate: Date?
    @State var selectedDate: Date = Date()
    
    var body: some View {
            Form {
                Section(content: {
                    DatePicker("\(selectedDate.formatted(date: .abbreviated, time: .omitted))", selection: $selectedDate, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                }, header: { Text("Select expiration date:     \(selectedDate.formatted(date: .abbreviated, time: .omitted))")})
            }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    expDate = selectedDate
                    isPresented.wrappedValue.dismiss()
                }, label: { Text("Save")})
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { isPresented.wrappedValue.dismiss() }, label: { Text("Cancel")})
            }
        }
    }
}

struct ExpirationDateSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ExpirationDateSelectionView(expDate: .constant(Date()))
    }
}
