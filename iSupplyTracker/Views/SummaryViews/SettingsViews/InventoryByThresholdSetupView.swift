//
//  InventoryByThresholdSetupView.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 18.04.22.
//

import SwiftUI

struct InventoryByThresholdSetupView: View {
  
    
    var isSaveable: Bool = true
    
    var keys: [String : Any] = [:]
    
    var body: some View {
        Text("Threshold")
    }
}

struct InventoryByThresholdSetupView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryByThresholdSetupView()
    }
}
