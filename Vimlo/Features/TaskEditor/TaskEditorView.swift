//
//  TaskEditorView.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import SwiftData
import SwiftUI

struct TaskEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: TaskEditorViewModel

    init(task: Task? = nil) {
        _viewModel = State(initialValue: TaskEditorViewModel(task: task))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        Form {
            TextField("Title", text: $viewModel.draft.title)
            TextField("Note", text: $viewModel.draft.note, axis: .vertical)

            Toggle("Due date", isOn: $viewModel.draft.hasDueDate)

            if viewModel.draft.hasDueDate {
                DatePicker("Due date", selection: $viewModel.draft.dueDate, displayedComponents: .date)
            }

            if viewModel.canComplete || viewModel.canDelete {
                Section("Actions") {
                    if viewModel.canComplete {
                        Button("Mark as Completed") {
                            try? viewModel.complete(in: modelContext)
                            dismiss()
                        }
                        .tint(.green)
                    }

                    if viewModel.canDelete {
                        Button("Delete Task", role: .destructive) {
                            try? viewModel.delete(in: modelContext)
                            dismiss()
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(viewModel.saveTitle) {
                try? viewModel.save(in: modelContext)
                dismiss()
            }
            .disabled(!viewModel.isSaveEnabled)
        }
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
