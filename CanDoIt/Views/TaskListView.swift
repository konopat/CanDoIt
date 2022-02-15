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
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in // For dynamic size calculations.
                ScrollView { // If you want to place something other than a List on this view.
                    VStack {
                        
                        // MARK: - Add field
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
                            .background(.white) // Only for iOS 15 and above
                        }
                        .padding(.top)
                        .padding(.bottom, 5)
                        .padding(.horizontal)
                        
                        // MARK: - List of items
                        List {
                            ForEach(viewModel.tasks) { task in
                                HStack {
                                    NavigationLink {
                                        Text("There will be an editing View")
                                    } label: {
                                        TaskListRowView(task: task)
                                    }
                                }
                                .onDrag {
                                    return NSItemProvider()
                                    // Combination with NSItemProvider() on drag gesture and .OnMove function
                                    // allows the ability to move tasks by simply grabbing the one you need
                                    // without activating the edit mode.
                                }
                            }
                            .onDelete(perform: deleteItems)
                            .onMove(perform: move) // Paired with a NSItemProvider() activates dragg and drop opportunities.
                        }
                        .listStyle(PlainListStyle()) // Removes defaults padding.
                        .frame(height: geometry.size.height) // Required for Scrollview to work properly.
                        .padding(.horizontal)
                        
                        
                        // MARK: - Navigation bar
                        .navigationTitle("CanDoIt")
                        .navigationBarTitleDisplayMode(.inline)
//                        .toolbar { // Toolbar buttons
//                            // Leading button
//                            ToolbarItem(placement: .navigationBarLeading) {
//                                EditButton()
//                            }
//                            // Trailing button
//                            ToolbarItem(placement: .navigationBarTrailing) {
//                                Button {
//                                    // Options
//                                } label: {
//                                    Image(systemName: "gear")
//                                }
//                            }
//                        }
                    }
                    .background(Color(UIColor.systemGray6)) // Only for iOS 15 and above
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
    
    private func move(the source: IndexSet, to destination: Int) {
        viewModel.move(from: source, to: destination)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: TaskListViewModel())
    }
}
