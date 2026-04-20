//
//  TaskEditorView.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import SwiftData
import SwiftUI

struct TaskEditorView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Bindable var task: Task
    
    @State private var viewModel = TaskEditorViewModel()
    @State private var saveErrorMessage: String?
    
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $viewModel.taskDraft.title)
                TextField("Note", text: $viewModel.taskDraft.note, axis: .vertical)
                    .lineLimit(3...6)
                Toggle("Due date", isOn: $viewModel.taskDraft.hasDueDate)
                    .onChange(of: viewModel.taskDraft.hasDueDate) { _, hasDueDate in
                        if hasDueDate && viewModel.taskDraft.dueDate == nil {
                            viewModel.taskDraft.dueDate = Calendar.current.startOfDay(for: .now)
                        }
                        
                        if !hasDueDate {
                            viewModel.taskDraft.dueDate = nil
                        }
                    }
                
                if viewModel.taskDraft.hasDueDate {
                    DatePicker("Due date", selection: dueDateBinding, displayedComponents: .date)
                }
            }
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    do {
                        try viewModel.save(context: modelContext)
                        dismiss()
                    } catch {
                        saveErrorMessage = error.localizedDescription
                    }
                }
                .disabled(!viewModel.taskDraft.isSaveEnabled)
            }
            .alert("Could not save task", isPresented: saveErrorMessageBinding) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveErrorMessage ?? "Please try again.")
            }
        }
        
        
    }
    
    private var dueDateBinding: Binding<Date> {
        Binding(
            get: {
                viewModel.taskDraft.dueDate ?? Calendar.current.startOfDay(for: .now)
            },
            set: { newValue in
                viewModel.taskDraft.dueDate = newValue
            }
        )
    }

    private var saveErrorMessageBinding: Binding<Bool> {
        Binding(
            get: { saveErrorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    saveErrorMessage = nil
                }
            }
        )
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
