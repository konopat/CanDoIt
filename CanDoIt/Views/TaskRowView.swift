//
//  TaskRowView.swift
//  CanDoIt
//
//  Created by Роман Предеин on 11.02.2022.
//

import SwiftUI

struct TaskRowView: View {
    let task: Task
    var body: some View {
        if let timestamp = task.timestamp, let taskTitle = task.title {
            HStack {
                Text("\(taskTitle)")
                Spacer()
                Text("\(timestamp, formatter: K.dateFormatter)")
                    .font(.caption)
            }
        } else {
            Text("Invalid task")
        }
    }
}

struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: Task()) // Need preview example
    }
}
