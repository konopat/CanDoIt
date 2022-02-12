//
//  ContentView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var modelView: ToDoListModelView

    var body: some View {
        
        NavigationView {
            List {
                ForEach(modelView.tasks) { task in
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
        .navigationViewStyle(StackNavigationViewStyle()) // Fix problem with constraint warning
    }
    private func addNewTask(_ title: String) {
        modelView.addTask(title)
    }
    private func deleteItems(offsets: IndexSet) {
        modelView.deleteTask(offsets: offsets)
    }
    private func loadItems() {
        modelView.getTasks()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(modelView: ToDoListModelView())
    }
}
