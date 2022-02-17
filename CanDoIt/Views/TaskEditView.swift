//
//  TaskEditView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 16.02.2022.
//

import SwiftUI

struct TaskEditView: View {
    
    @ObservedObject var viewModel: TaskListViewModel // Need for save changes
    @State var textFieldValue = "" // task.title
    @State var textEditorValue = "" // task.note
    @State var notePlaceholder = "You can type a new note here"
    
    let task: Task // The view waiting a task
    
    var body: some View {
        VStack {
            titleEditor
            noteEditor
        }
        .padding()
        .onAppear(perform: getTitleValue) // Get current task title
    }
    
    
    // MARK: - Subviews
    
    // TitleEditorView
    var titleEditor: some View {
        TextField("New task", text: $textFieldValue)
            .font(.title)
            .onDisappear(perform: saveData)
    }
    
    // NoteEditorView
    var noteEditor: some View {
        ZStack {
            if textEditorValue == "" {
                TextEditor(text: $notePlaceholder)
                        .font(.title2)
                        .foregroundColor(.gray)
                        .disabled(true)
            }
            TextEditor(text: $textEditorValue)
                .font(.title2)
                .opacity(textEditorValue == "" ? 0.25 : 1)
                .onDisappear(perform: saveData)
        }
    }
    
    // MARK: - Functions
    
    private func getTitleValue() {
        if let taskTitle = task.title {
            textFieldValue = taskTitle
            if let taskNote = task.note {
                textEditorValue = taskNote
            }
        }
    }
    
    private func saveData() {
        task.title = textFieldValue
        task.note = textEditorValue
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
