//
//  CanDoItApp.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI

@main
struct CanDoItApp: App {
    
    let persistenceController = PersistenceController.shared
    let secretary = Secretary()

    var body: some Scene {
        WindowGroup {
            ContentView(secretary: secretary)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
