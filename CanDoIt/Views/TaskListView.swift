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
    @State var textFieldValue = ""
    
    @State private var appendedItems: Int = 0
    @State private var deletedItems: Int = 0
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        // Add field
                        Group {
                            HStack {
                                TextField("New task", text: $textFieldValue)
                                Button {
                                    addNewTask()
                                } label: {
                                    Text("Add")
                                }
                            }
                            .padding()
                            .background(.white)
                        }
                        .padding(.top)
                        .padding(.bottom, 5)
                        .padding(.horizontal)
                        
                        List {
                            ForEach(viewModel.tasks) { task in
                                NavigationLink {
                                    Text("There will be an editing View")
                                } label: {
                                    TaskListRowView(task: task)
                                }
                            }
                            .onDelete(perform: deleteItems)
                            .onMove(perform: move)
                            
                        }
                        .listStyle(PlainListStyle())
                        .frame(height: geometry.size.height)
                        .padding(.horizontal)
                        
                        
                        // Navigation bar
                        .navigationTitle("CanDoIt")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    // Options
                                } label: {
                                    Image(systemName: "gear")
                                }

                            }
                            ToolbarItem(placement: .navigationBarLeading) {
                                EditButton()
                            }
                            
                        }
                    }
                    .background(Color(UIColor.systemGray6))
                }
            }
            
        }
        .onAppear(perform: loadItems)
        .navigationViewStyle(StackNavigationViewStyle()) // Fix problem with constraint warning
    }
    
    private func addNewTask() {
        
        if textFieldValue != "" {
            if appendedItems - deletedItems == 0 {
                viewModel.addNewItem(with: textFieldValue, and: 0 )
                appendedItems = 0
                deletedItems = 0
            } else {
                viewModel.addNewItem(with: textFieldValue, and: appendedItems + deletedItems )
            }
            textFieldValue = ""
            appendedItems += 1
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        viewModel.deleteItems(by: offsets)
        deletedItems += 1
    }
    
    private func loadItems() {
        viewModel.loadData()
    }
    
    private func move(the source: IndexSet, to destination: Int) {
        viewModel.move(from: source, to: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: TaskListViewModel())
    }
}
