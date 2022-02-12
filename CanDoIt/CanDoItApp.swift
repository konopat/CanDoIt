//
//  CanDoItApp.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI

@main
struct CanDoItApp: App {
    
    let modelView = ToDoListModelView()

    var body: some Scene {
        WindowGroup {
            ContentView(modelView: modelView)
        }
    }
}
