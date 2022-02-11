//
//  ToDoListModelView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI
import CoreData

class ToDoListModelView: ObservableObject {
    
    let container: NSPersistentContainer

    @Published var tasks: [Task] = []

    init() {
        container = NSPersistentContainer(name: K.persistentContainerName) //exactname of the CoreData file
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }

    func getTasks() {
        let request = NSFetchRequest<Task>(entityName: K.entityName) //exact name as in the CoreData file
        
        do {
            try tasks = container.viewContext.fetch(request)
        } catch {
            print("Error getting data. \(error.localizedDescription)")
        }
        
        
    }

    func addTask(_ title: String) {
        let newTask = Task(context: container.viewContext)
        newTask.id = UUID()
        newTask.isDone = false
        newTask.title = title
        newTask.timestamp = Date()
        saveData()
    }
    
    func deleteTask(offsets: IndexSet) {
            withAnimation {
                offsets.map { tasks[$0] }.forEach(container.viewContext.delete)
                saveData()
            }
        }

    func saveData() {
        do {
            try container.viewContext.save()
            getTasks() //to update the published variable to reflect this change
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    // Request entries from CoreData
//    @FetchRequest(
//        // Sort by Date()
//        sortDescriptors: [NSSortDescriptor(
//            keyPath: \Task.timestamp,
//            ascending: true
//        )],
//        // The result can be animated
//        animation: .default)
//    // Get the result on request
//    private var fetchedTasks: FetchedResults<Task>
//
//    @Published private var tasks = createToDoList()
//
//    private static func createToDoList() -> [Task] {
//        var items: [Task]
//        for item in fetchedTasks {
//            items.append(item)
//        }
//        return items
//    }
//
//    func addToTheList(the newTask: Task, with context: NSManagedObjectContext) {
//        tasks.append(newTask)
//        if context.hasChanges {
//            saveData(with: context)
//            print(fetchedTasks.count)
//        }
//    }
//
//    func saveData(with context: NSManagedObjectContext) {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context: \(error)")
//        }
//    }
//
//    func loadData(with context: NSManagedObjectContext) {
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//        do {
//            tasks = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//    }
}
