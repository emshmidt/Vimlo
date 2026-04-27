//
//  TaskHomeView.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import SwiftData
import SwiftUI

struct TaskHomeView: View {
    @Query(filter: #Predicate<Task> { !$0.isCompleted }) var tasks: [Task]
    @Query(filter: #Predicate<Task> { $0.isCompleted }) var completedTasks: [Task]
    
    @State private var viewModel = TaskHomeViewModel()
    
    
    var body: some View {
        let sections = viewModel.makeSections(tasks: tasks)
        
        NavigationStack {
            Group {
                if viewModel.isEmpty(tasks: tasks) {
                    VStack {
                        if completedTasks.count > 0 {
                            NavigationLink(
                                destination: CompletedTasksView(),
                                label: {
                                    CompletedEntryRowView(
                                        completedCount: completedTasks.count,
                                        isEmphasized: true
                                    )
                                }
                            )
                            .buttonStyle(.plain)
                        }
                        
                        ContentUnavailableView(
                            "No Active Tasks Yet",
                            systemImage: "checklist",
                            description: Text("Add your first task to get started.")
                        )
                    }
                } else {
                    List {
                        if completedTasks.count > 0 {
                            NavigationLink(
                                destination: CompletedTasksView(),
                                label: {
                                    CompletedEntryRowView(completedCount: completedTasks.count)
                                }
                            )
                        }
                        
                        ForEach(sections) { section in
                            Section(section.title) {
                                ForEach(section.tasks) { task in
                                    TaskRowView(
                                        task: task,
                                        onDelete: viewModel.delete,
                                        onComplete: viewModel.complete
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                Button("Add task", systemImage: "plus") {
                    viewModel.tappedPlusButton()
                }
            }
            .sheet(isPresented: $viewModel.isAddTaskSheetPresented){
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
