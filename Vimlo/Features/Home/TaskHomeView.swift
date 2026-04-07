//
//  TaskHomeView.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import SwiftData
import SwiftUI

struct TaskHomeView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Task.title) var tasks: [Task]
    @State private var path = [Task]()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(tasks) {task in
                NavigationLink(value: task) {
                    Text(task.title)
                }
            }
            .navigationTitle("Tasks")
            .navigationDestination(for: Task.self) { task in
                TaskEditorView(task: task)
            }
            .toolbar {
                Button("Add task", systemImage: "plus") {
                    let task = Task(title: "")
                    modelContext.insert(task)
                    path = [task]
                }
            }
        }
    }
}

#Preview {
    TaskHomeView()
}
