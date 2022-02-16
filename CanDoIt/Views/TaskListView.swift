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
    @FocusState private var focusedField: Field?
    @State var textFieldValue = ""
    
    enum Field: Hashable {
        case textField
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in // For dynamic size calculations.
                ScrollView { // If you want to place something other than a List on this view.
                    VStack {
                        
                        // MARK: - Add field
                        
                        Group {
                            HStack {
                                TextField("New task", text: $textFieldValue)
                                    .focused($focusedField, equals: .textField)
                                Button {
                                    focusedField = nil
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
                                        TaskEditView(viewModel: viewModel, task: task)
                                    } label: {
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
                    }
                    .background(Color(UIColor.systemGray6)) // Only for iOS 15 and above
                }
            }
            
        }
        .onAppear(perform: loadItems)
        .navigationViewStyle(StackNavigationViewStyle()) // Fix problem with constraint warning
    }
    
    // MARK: - Functions
    
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

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: TaskListViewModel())
    }
}
