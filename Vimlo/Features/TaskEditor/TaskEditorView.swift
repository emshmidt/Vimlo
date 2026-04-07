//
//  TaskEditorView.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import SwiftData
import SwiftUI

struct TaskEditorView: View {
    @Bindable var task: Task
    
    var body: some View {
        Form {
            TextField("Title", text: $task.title)
            //TextField("Note", text: $task.note)
            //DatePicker("Due date", selection: $task.dueDate)
            //task.updatedAt = .now
        }
        .navigationTitle("Edit Task")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Task.self, configurations: config)
        let task = Task(title: "New Task")
        
        return TaskEditorView(task: task)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }

}
