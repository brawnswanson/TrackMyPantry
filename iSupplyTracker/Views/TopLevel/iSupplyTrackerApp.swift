//
//  iSupplyTrackerApp.swift
//  iSupplyTracker
//
//  Created by Daniel Pressner on 22.03.22.
//

import SwiftUI

@main
struct iSupplyTrackerApp: App {
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, CoreDataCoordinator.sharedCoreData.context)
                .onAppear(perform: { print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)) })
        }
    }
}


