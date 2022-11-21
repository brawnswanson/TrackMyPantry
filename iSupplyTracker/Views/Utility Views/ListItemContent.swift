//
//  ListItemContent.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 23.03.22.
//

import SwiftUI

struct ListItemContent: View {
    
    var action: (() -> ())?
    var headerValues: [(text: String, relativeWidth: Double)]
    var totalRelativeWidth: Double {
        var total = 0.0
        for value in headerValues {
            total += value.relativeWidth
        }
        return total
    }
    
    var body: some View {
        listItemView
    }
}

extension ListItemContent {
    
    @ViewBuilder
    var listItemView: some View {
        if let closure = action {
            Button(action: closure, label: {
                completeRow
            })
        }
        else {
            completeRow
        }
    }
    
    var completeRow: some View {
        HStack {
            rowContent
            chevron
        }
    }
    
    @ViewBuilder
    var chevron: some View {
        if let _ = action {
            Image(systemName: "chevron.right")
        }
        else {
            Image(systemName: "chevron.right").hidden()
        }
    }
    
    var rowContent: some View {
        GeometryReader(content: { geometry in
            HStack {
                ForEach(headerValues, id:\.text) { value in
                    Text(value.text)
                        .frame(width: geometry.frame(in: .local).width * widthPercent(for: value.relativeWidth), alignment: .leading)
                }
                
            }
        })
    }
}

extension ListItemContent {
    func widthPercent(for relativeWidth: Double) -> Double {
        relativeWidth / totalRelativeWidth
    }
}
