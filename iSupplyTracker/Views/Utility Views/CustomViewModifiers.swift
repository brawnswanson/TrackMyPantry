//
//  CustomViewModifiers.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 03.04.22.
//

import SwiftUI

struct CustomTabItem: ViewModifier {
   
    let tabImage: String
    let label: String
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                VStack {
                    Image(systemName: tabImage)
                    Text(label)
                }
            }
    }
}

extension View {
    func customTabItem(tabImage: String, label: String) -> some View {
        modifier(CustomTabItem(tabImage: tabImage, label: label))
    }
}
