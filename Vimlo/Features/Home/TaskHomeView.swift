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
    @Query(filter: #Predicate<Task> { !$0.isCompleted }) var tasks: [Task]
    //var tasks: [Task] = [
        //Task(title: "Test task", dueDate: .now),
        //Task(title: "Test task"),
        //Task(title: "Test task"),
    //]
    //@State private var path = [Task]()
    @State private var viewModel = TaskHomeViewModel()
    
    
    
    var body: some View {
        let sections = viewModel.makeSections(tasks: tasks)
        
        NavigationStack {
            Group {
                if viewModel.isEmpty(tasks: tasks) {
                    ContentUnavailableView(
                        "No Active Tasks Yet",
                        systemImage: "checklist",
                        description: Text("Add your first task to get started.")
                    )
                } else {
                    List {
                        ForEach(sections) { section in
                            Section(section.title) {
                                ForEach(section.tasks) { task in
                                    Text(task.title)
                                }
                            }
                        }
                    }
                }
            }
            
            .navigationTitle("Tasks")
            .navigationDestination(for: Task.self) { task in
                TaskEditorView(task: task)
            }
            .toolbar {
                Button("Add task", systemImage: "plus") {
                    viewModel.tappedPlusButton()
                }
            }
            .sheet(isPresented: $viewModel.isAddTaskSheetPresented){
                let task = Task(title: "")
                NavigationLink("hey", destination: TaskEditorView(task: task))
                //TaskEditorView()
            }
            
        }
    }
}

#Preview {
    TaskHomeView()
}
