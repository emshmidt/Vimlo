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
    
    @State private var viewModel: TaskEditorViewModel
    @State private var saveErrorMessage: String?
    
    
    init() {
        _viewModel = State(initialValue: TaskEditorViewModel())
    }
    
    init(task: Task) {
        _viewModel = State(initialValue: TaskEditorViewModel(task: task))
    }
    
    var body: some View {
        ZStack {
            VimloTheme.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(viewModel.mode == .create ? "A gentle reminder" : "Polish the details")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(VimloTheme.secondaryInk)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(VimloTheme.brandPink.opacity(0.82))
                                )

                            if viewModel.taskDraft.isCompleted {
                                Text("Completed")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(VimloTheme.completedAccent)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(VimloTheme.completedSurface)
                                    )
                            }
                        }

                        Text(viewModel.mode == .create ? "Capture just enough to remember it later." : "Keep the task clear, light, and easy to act on.")
                            .font(.subheadline)
                            .foregroundStyle(VimloTheme.secondaryInk)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(editorCardBackground(accent: VimloTheme.brandPink))

                    VStack(alignment: .leading, spacing: 12) {
                        EditorSectionTitle(title: "Task title")
                        TextField("Read chapter 3", text: $viewModel.taskDraft.title)
                            .font(.system(.title3, design: .rounded).weight(.semibold))
                            .foregroundStyle(VimloTheme.ink)
                            .padding(18)
                            .background(editorInputBackground(accent: VimloTheme.brandPink))
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        EditorSectionTitle(title: "Note")
                        TextField("A soft reminder or a little more context", text: $viewModel.taskDraft.note, axis: .vertical)
                            .font(.body)
                            .foregroundStyle(VimloTheme.ink)
                            .lineLimit(4...8)
                            .padding(18)
                            .background(editorInputBackground(accent: VimloTheme.oat))
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        EditorSectionTitle(title: "Date")

                        VStack(spacing: 14) {
                            Toggle(isOn: $viewModel.taskDraft.hasDueDate) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Due date")
                                        .font(VimloTheme.cardTitleFont)
                                        .foregroundStyle(VimloTheme.ink)
                                    Text("Turn it on when you want a gentle nudge in the list.")
                                        .font(.caption)
                                        .foregroundStyle(VimloTheme.secondaryInk)
                                }
                            }
                            .tint(VimloTheme.pinkAccent)
                            .onChange(of: viewModel.taskDraft.hasDueDate) { _, hasDueDate in
                                if hasDueDate && viewModel.taskDraft.dueDate == nil {
                                    viewModel.taskDraft.dueDate = Calendar.current.startOfDay(for: .now)
                                }

                                if !hasDueDate {
                                    viewModel.taskDraft.dueDate = nil
                                }
                            }

                            if viewModel.taskDraft.hasDueDate {
                                Divider()
                                    .overlay(VimloTheme.line)

                                DatePicker("Choose a date", selection: dueDateBinding, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                                    .tint(VimloTheme.pinkAccent)
                                    .foregroundStyle(VimloTheme.ink)
                            }
                        }
                        .padding(18)
                        .background(editorCardBackground(accent: VimloTheme.butter))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        EditorSectionTitle(title: "Status")

                        Button(viewModel.taskDraft.isCompleted ? "Reactivate task" : "Mark as completed") {
                            viewModel.onToggleCompletion()
                        }
                        .font(VimloTheme.buttonFont)
                        .foregroundStyle(VimloTheme.ink)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(viewModel.taskDraft.isCompleted ? VimloTheme.mist : VimloTheme.sage)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(Color.white.opacity(0.7), lineWidth: 1)
                        )
                        .buttonStyle(.plain)
                    }

                    if viewModel.mode == .edit {
                        VStack(alignment: .leading, spacing: 12) {
                            EditorSectionTitle(title: "Danger zone")

                            Button(role: .destructive) {
                                viewModel.deleteTapped()
                            } label: {
                                Text("Delete task")
                                    .font(VimloTheme.buttonFont)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .foregroundStyle(VimloTheme.roseAccent)
                                    .background(editorCardBackground(accent: VimloTheme.rose))
                            }
                            .buttonStyle(.plain)
                            .confirmationDialog(
                                "Delete task?",
                                isPresented: $viewModel.isDeletePresented,
                                titleVisibility: .visible
                            ) {
                                Button("Delete", role: .destructive) {
                                    delete()
                                }

                                Button("Cancel", role: .cancel) {
                                    viewModel.isDeletePresented = false
                                }
                            } message: {
                                Text("This action cannot be undone.")
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.mode == .create {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                save()
            } label: {
                Text(viewModel.saveTitle)
                    .font(VimloTheme.buttonFont)
                    .foregroundStyle(viewModel.taskDraft.isSaveEnabled ? VimloTheme.ink : VimloTheme.secondaryInk)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(viewModel.taskDraft.isSaveEnabled ? VimloTheme.brandPink : VimloTheme.oat)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.72), lineWidth: 1)
                    )
                    .shadow(color: VimloTheme.shadow, radius: 16, y: 10)
            }
            .disabled(!viewModel.taskDraft.isSaveEnabled)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 8)
            .background(VimloTheme.background.opacity(0.94))
        }
        .alert("Error", isPresented: saveErrorMessageBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveErrorMessage ?? "Please try again.")
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

private struct EditorSectionTitle: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(.subheadline, design: .rounded).weight(.semibold))
            .foregroundStyle(VimloTheme.secondaryInk)
    }
}

private func editorCardBackground(accent: Color) -> some View {
    RoundedRectangle(cornerRadius: 28, style: .continuous)
        .fill(VimloTheme.cardBackground.opacity(0.985))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(accent.opacity(0.9), lineWidth: 1.2)
        )
        .shadow(color: VimloTheme.shadow, radius: 16, y: 10)
}

private func editorInputBackground(accent: Color) -> some View {
    RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(VimloTheme.cardBackground.opacity(0.985))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(accent.opacity(0.9), lineWidth: 1.2)
        )
        .shadow(color: VimloTheme.shadow.opacity(0.75), radius: 10, y: 6)
}
