//
//  ContentView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 09.02.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var secretary: Secretary
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.timestamp, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Task>

    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        HStack {
                            Text(item.title!)
                            Text(item.timestamp!, formatter: itemFormatter)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Task(context: viewContext)
            newItem.timestamp = Date()
            newItem.id = UUID()
            newItem.title = "Test"
            newItem.isDone = false
            secretary.addToTheList(the: newItem, with: viewContext)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            secretary.saveData(with: viewContext)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(secretary: Secretary()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
