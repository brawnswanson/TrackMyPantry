//
//  BarCode.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 26.03.22.
//

import Foundation

struct BarCode: Identifiable {
    let code: String
    var id: String {
        code
    }
}
