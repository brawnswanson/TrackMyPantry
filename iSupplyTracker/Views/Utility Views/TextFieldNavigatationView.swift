//
//  TextFieldNavigatationView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 23.03.22.
//
//IMP: If there is no value sent, I'd like a grayed out prompt. How do I get that?

import SwiftUI

struct TextFieldNavigatationView: View {
    
    @State var ifEmptyLabel: String
    @State var title: String
    @Binding var text: String
    
    var body: some View {
        NavigationLink(destination: {
            Form {
                Section {
                    TextField("title", text: $text, prompt: Text(text == "" ? ifEmptyLabel : text ))
                }
                
            }}, label: {
                HStack {
                    Text(title)
                    Spacer()
                    Text(text)
                }.foregroundColor(.gray)
            })
    }
}
