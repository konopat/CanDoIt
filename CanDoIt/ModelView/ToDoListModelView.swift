//
//  ToDoListModelView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI
import CoreData

class ToDoListModelView: ObservableObject {
    
    private let persistenceController = PersistenceController.shared

    @Published var tasks: [Task] = []

    func getTasks() {        
        let request = NSFetchRequest<Task>(entityName: K.entityName)
        do {
            try tasks = persistenceController.container.viewContext.fetch(request)
        } catch {
            print("Error getting data. \(error.localizedDescription)")
        }
    }

    func addTask(_ title: String) {
        let newTask = Task(context: persistenceController.container.viewContext)
        newTask.id = UUID()
        newTask.isDone = false
        newTask.title = title
        newTask.timestamp = Date()
        saveData()
    }
    
    func deleteTask(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(persistenceController.container.viewContext.delete)
            saveData()
        }
    }

    func saveData() {
        if persistenceController.container.viewContext.hasChanges {
            do {
                try persistenceController.container.viewContext.save()
                getTasks() //to update the published variable to reflect this change
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
}
