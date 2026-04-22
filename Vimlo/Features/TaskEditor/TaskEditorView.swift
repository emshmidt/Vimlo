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
    
    //@Bindable var task: Task
    
    @State private var viewModel: TaskEditorViewModel
    @State private var saveErrorMessage: String?
    
    
    init() {
        _viewModel = State(initialValue: TaskEditorViewModel())
    }
    
    init(task: Task) {
        _viewModel = State(initialValue: TaskEditorViewModel(task: task))
    }
    
    var body: some View {
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
            
            Section {
                if viewModel.mode == .edit {
                    Button("Delete task", role: .destructive) {
                        viewModel.deleteTapped()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Save") {
                save()
            }
            .disabled(!viewModel.taskDraft.isSaveEnabled)
        }
        .alert("Error", isPresented: saveErrorMessageBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveErrorMessage ?? "Please try again.")
        }
        .confirmationDialog("Delete task?",
                            isPresented: $viewModel.isDeletePresented,
                            titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                delete()
            }
            
            Button("Cancel", role: .cancel) {
                
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
    
    func delete() {
        do {
            try viewModel.delete(context: modelContext)
            dismiss()
        } catch {
            saveErrorMessage = error.localizedDescription
        }
    }
    
    func save() {
        do {
            try viewModel.save(context: modelContext)
            dismiss()
        } catch {
            saveErrorMessage = error.localizedDescription
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
