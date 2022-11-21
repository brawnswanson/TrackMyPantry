//
//  ContentView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 22.03.22.
//

import SwiftUI

struct ContentView: View {
    
    @State var labelText: String = "Dan"
    
    var body: some View {
        VStack {
            Button(action: {
                if self.labelText == "Dan" {
                    self.labelText = "Kristen"
                } else {
                    self.labelText = "Dan"
                }
            }, label: { Text("Change text")})
//            ScannerView(text: $labelText)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
