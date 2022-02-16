//
//  TaskEditView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 16.02.2022.
//

import SwiftUI

struct TaskEditView: View {
    
    @ObservedObject var viewModel: TaskListViewModel // Need for save changes
    @State var textEditorValue = ""
    let task: Task
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    TextEditor(text: $textEditorValue)
                        .font(.title2)
                        .onDisappear(perform: saveData)
                }
            }
            Spacer()
        }
        .padding()
        .onAppear(perform: getTitleValue) // Get current task title
    }
    
    // MARK: - Functions
    
    private func getTitleValue() {
        if let taskTitle = task.title {
            textEditorValue = taskTitle
        }
    }
    
    private func saveData() {
        task.title = textEditorValue
        viewModel.saveData()
    }
}

// MARK: - Preview

struct TaskEditView_Previews: PreviewProvider {
    
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
        TaskEditView(viewModel: TaskListViewModel(), task: testTask)
            .environment(\.managedObjectContext, persistence.container.viewContext)
    }
}
