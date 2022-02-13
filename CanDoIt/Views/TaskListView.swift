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
    @State private var showingSheet = false

    var body: some View {
        
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        
                        
                        
                        List {
                            ForEach(viewModel.tasks) { task in
                                NavigationLink {
                                    Text("There will be an editing View")
                                } label: {
                                    TaskListRowView(task: task)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .frame(height: geometry.size.height)
                        
                        .sheet(isPresented: $showingSheet) {
                            VStack {
                                HStack {
                                    TextField("New task", text: $textFieldValue)
                                    Button {
                                        addNewTask()
                                        showingSheet.toggle()
                                    } label: {
                                        Text("Add")
                                    }
                                }
                                .padding()
                                .background(.white)
                            }
                            .cornerRadius(10)
                            .padding(.top)
                            .padding(.horizontal)
                        }
                        
                        // Navigation bar
                        .navigationTitle("CanDoIt")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
                            ToolbarItem {
                                Button {
                                    showingSheet.toggle()
                                } label: {
                                    Image(systemName: "plus")
                                }

                            }
                        }
                    }.background(Color(UIColor.systemGray6))
                }
            }
            
        }
        .onAppear(perform: loadItems)
        .navigationViewStyle(StackNavigationViewStyle()) // Fix problem with constraint warning
    }
    private func addNewTask() {
        if textFieldValue != "" {
            viewModel.addNewItem(with: textFieldValue)
            textFieldValue = ""
        }
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
