//
//  Persistence.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import CoreData

struct PersistenceController { // Allows to initialize and manage local storage
    
    // Create a local storage container
    let container = NSPersistentContainer(name: K.persistentContainerName)

    init() { // When the controller is initialized
        // Load all stores from the container
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
}
