//
//  TaskRowView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 11.02.2022.
//

import SwiftUI
import CoreData

struct TaskRowView: View {
    let task: Task
    var body: some View {
        if let timestamp = task.timestamp, let taskTitle = task.title {
            HStack {
                Text("\(taskTitle)")
                Spacer()
                Text("\(timestamp, formatter: K.dateFormatter)")
                    .font(.caption)
            }
        } else {
            Text("Invalid task")
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    
    static let persistence = PersistenceController.preview
    
    static var testTask: Task = {
        let context = persistence.container.viewContext
        let testTask = Task(context: context)
        testTask.id = UUID()
        testTask.isDone = false
        testTask.title = "Тестовая задача"
        testTask.timestamp = Date()
        return testTask
    }()
    
    static var previews: some View {
        TaskRowView(task: testTask)
            .environment(\.managedObjectContext, persistence.container.viewContext)
    }
}
