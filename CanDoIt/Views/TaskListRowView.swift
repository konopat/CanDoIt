//
//  TaskListRowView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 11.02.2022.
//

import SwiftUI
import CoreData

struct TaskListRowView: View {
    let task: Task
    var body: some View {
        if let taskTitle = task.title {
            HStack {
                Text("\(taskTitle)")
                Spacer()
            }
            .padding(.vertical)
        } else {
            Text("Invalid task")
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    
    static let persistence = PersistenceController()
    
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
        TaskListRowView(task: testTask)
            .environment(\.managedObjectContext, persistence.container.viewContext)
    }
}
