//
//  CompletedTasksView.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 23.04.2026.
//

import SwiftUI
import SwiftData

struct CompletedTasksView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Task> { $0.isCompleted }) var tasks: [Task]
    @State private var viewModel = CompletedTasksViewModel()
    
    var body: some View {
        Group {
            if viewModel.isEmpty(tasks: tasks) {
                ContentUnavailableView(
                    "No Completed Tasks Yet",
                    systemImage: "checklist",
                    description: Text("Complete your first task.")
                )
            } else {
                List {
                    ForEach (viewModel.sortedTasks(tasks: tasks)) { task in
                        TaskRowView(task: task,
                                    onDelete: viewModel.delete,
                                    onComplete: viewModel.reactivate)
                    }
                }
                .navigationTitle("Completed tasks")
                
            }
            
        }
    }
}

#Preview {
    CompletedTasksView()
}
