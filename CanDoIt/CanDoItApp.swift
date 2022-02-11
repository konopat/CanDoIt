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
    let secretary = ToDoListModelView()

    var body: some Scene {
        WindowGroup {
            ContentView(toDoListModelView: secretary)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
