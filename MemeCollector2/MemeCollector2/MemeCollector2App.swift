//
//  MemeCollector2App.swift
//  MemeCollector2
//
//  Created by Andree Carlsson on 2022-09-23.
//

import SwiftUI

@main
struct MemeCollector2App: App {
    // MARK: Här initierar vi PersistenceControllern som vi byggt i filen "Persistence"
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                StartView()
                var _ = print("appen startar")
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}

