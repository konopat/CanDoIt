//
//  TaskListViewModel.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI
import CoreData

class TaskListViewModel: ObservableObject {
    
    // The Task class is automatically generated by CoreData when we create an entity
    // We will use an alias EntityModel only for better understanding
    typealias EntityModel = Task
    
    // For the first run, the task list will be empty
    // Than we need to track changes with @Published property wrapper
    @Published var tasks: [EntityModel] = []
    
    // Create managed local storage
    private let persistenceController = PersistenceController()

    // Loading data
    func loadData() {
        
        // Request objects that match our model
        let request = NSFetchRequest<EntityModel>(entityName: K.entityName)
        let sort = NSSortDescriptor(key: "order", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            // Try to load the result into the monitored array
            try tasks = persistenceController.container.viewContext.fetch(request)
        } catch {
            // If it doesn't work
            print("Error getting data. \(error.localizedDescription)")
        }
    }
    
    // Saving data
    func saveData() {
        
        // Only if changes are detected
        if persistenceController.container.viewContext.hasChanges {
            do {
                // Try to save all data in the currrent container
                try persistenceController.container.viewContext.save()
                
                // And load it again to update the published variable to reflect this change
                loadData()
            } catch let error {
                // If it doesn't work
                print("Error: \(error)")
            }
        }
    }

    // New data
    func addNewItem(with title: String, and order: Int) {
        
        // Initializing the creation of a new entity
        let newItem = EntityModel(context: persistenceController.container.viewContext)
        
        // Then assign values to all properties
        newItem.id = UUID()
        newItem.isDone = false
        newItem.title = title
        newItem.timestamp = Date()
        newItem.order = Int64(order)
        
        // And start saving
        saveData()
    }
    
    // Remove data
    func deleteItems(by offsets: IndexSet) {
        
        // Select all matches and start the removal cycle
        offsets.map { tasks[$0] }.forEach(persistenceController.container.viewContext.delete)
        
        // And start saving certainly
        saveData()
    }
    
    // Reorder
    func move(from source: IndexSet, to destination: Int) {
        
        // https://stackoverflow.com/questions/59742218/swiftui-reorder-coredata-objects-in-list
        
//        tasks.move(fromOffsets: source, toOffset: destination)
        
//        for reverseIndex in stride( from: tasks.count - 1,
//                                        through: 0,
//                                        by: -1 )
//        {
//            tasks[ reverseIndex ].order =
//                Int64( reverseIndex )
//        }
        
        saveData()
    }

    
}
