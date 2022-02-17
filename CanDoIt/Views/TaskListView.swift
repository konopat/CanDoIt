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
            GeometryReader { geometry in // For dynamic size calculations.
                ScrollView { // If you want to place something other than a List on this view.
                    VStack {
                        AddNewItemFieldView(viewModel: viewModel)
                        ListOfItemsView(viewModel: viewModel, geometry: geometry)
                    }
                    .background(Color(UIColor.systemGray6)) // Only for iOS 15 and above
                }
            }
            .navigationTitle("CanDoIt")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Fix problem with constraint warning
    }
    
}

// MARK: - SubViews

struct AddNewItemFieldView: View {
    
    @State var viewModel: TaskListViewModel
    @State var textFieldValue = ""
    
    // Tracks focus on a field
    @FocusState private var focusedField: Field?
    enum Field: Hashable {
        case textField
    }
    
    var body: some View {
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
    }
    
    private func addNewTask() {
        if textFieldValue != "" {
            viewModel.addNewItem(with: textFieldValue)
            textFieldValue = ""
        }
    }
    
}

struct ListOfItemsView: View {
    
    @State var viewModel: TaskListViewModel
    let geometry: GeometryProxy
    
    var body: some View {
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
        .onAppear(perform: loadItems)
    }
        
    
    private func loadItems() {
        viewModel.loadData()
    }
    
    private func move(the source: IndexSet, to destination: Int) {
        viewModel.move(from: source, to: destination)
    }
    
    private func deleteItems(offsets: IndexSet) {
        viewModel.deleteItems(by: offsets)
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(viewModel: TaskListViewModel())
    }
}
