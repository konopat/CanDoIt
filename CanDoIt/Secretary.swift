//
//  Secretary.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI
import CoreData

class Secretary: ObservableObject {
    
    @Published var tasks: [Task] = []
    
    func addToTheList(the newTask: Task, with context: NSManagedObjectContext) {
        tasks.append(newTask)
        if context.hasChanges {
            saveData(with: context)
        }
    }
    
    func saveData(with context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadData(with context: NSManagedObjectContext) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}
