//
//  ContentView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var toDoListModelView: ToDoListModelView
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        
        NavigationView {
            List {
                ForEach(toDoListModelView.tasks) { task in
                    NavigationLink {
                        Text("There will be an editing View")
                    } label: {
                        TaskRowView(task: task)
                    }
                }
                .onDelete(perform: deleteItems)
                .padding(.vertical)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        addNewTask("Test")
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .navigationTitle("You can do it!")
            .navigationViewStyle(.stack)
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear(perform: loadItems)
    }
    private func addNewTask(_ title: String) {
        toDoListModelView.addTask(title)
    }
    private func deleteItems(offsets: IndexSet) {
        toDoListModelView.deleteTask(offsets: offsets)
    }
    private func loadItems() {
        toDoListModelView.getTasks()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(toDoListModelView: ToDoListModelView())
    }
}
