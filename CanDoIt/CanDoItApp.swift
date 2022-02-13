//
//  CanDoItApp.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI

@main
struct CanDoItApp: App {
    
    let currentViewModel = TaskListViewModel()

    var body: some Scene {
        WindowGroup {
            TaskListView(viewModel: currentViewModel)
        }
    }
}
