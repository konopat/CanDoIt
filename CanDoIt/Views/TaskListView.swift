//
//  ContentView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    
    @ObservedObject var viewModel: TaskListViewModel

    var body: some View {
        
        NavigationView {
            List {
                ForEach(viewModel.tasks) { task in
                    NavigationLink {
                        Text("There will be an editing View")
                    } label: {
                        TaskListRowView(task: task)
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
        viewModel.addNewItem(with: title)
    }
    private func deleteItems(offsets: IndexSet) {
        viewModel.deleteItems(by: offsets)
    }
    private func loadItems() {
        viewModel.loadData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: TaskListViewModel())
    }
}
