//
//  TaskHomeView.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import SwiftData
import SwiftUI

struct TaskHomeView: View {
    @Environment(\.modelContext) private var modelContext

    //@Query(filter: #Predicate<Task> { !$0.isCompleted })
    @Query private var tasks: [Task]

    @State private var viewModel = TaskHomeViewModel()

    var body: some View {
        let sections = viewModel.sections(for: tasks)

        NavigationStack {
            Group {
                if viewModel.isEmpty(tasks: tasks) {
                    ContentUnavailableView(
                        "No Tasks Yet",
                        systemImage: "checklist",
                        description: Text("Add your first task to get started.")
                    )
                } else {
                    List {
                        ForEach(sections) { section in
                            Section(section.title) {
                                ForEach(section.tasks) { task in
                                    NavigationLink {
                                        TaskEditorView(task: task)
                                    } label: {
                                        Text(task.title)
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button("Delete", role: .destructive) {
                                            try? viewModel.delete(task, in: modelContext)
                                        }

                                        Button("Complete") {
                                            try? viewModel.complete(task, in: modelContext)
                                        }
                                        .tint(.green)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                Button("Add Task", systemImage: "plus") {
                    viewModel.didTapAddTask()
                }
            }
            .sheet(
                isPresented: $viewModel.isPresentingCreateSheet,
                onDismiss: {
                    viewModel.didDismissCreateSheet()
                }
            ) {
                NavigationStack {
                    TaskEditorView()
                }
            }
        }
    }
}


#Preview {
    TaskHomeView()
}
