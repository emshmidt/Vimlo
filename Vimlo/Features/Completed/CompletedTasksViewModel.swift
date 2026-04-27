//
//  CompletedTasksViewModel.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 23.04.2026.
//

import Foundation
import SwiftData

@Observable
class CompletedTasksViewModel {
    
    func isEmpty(tasks: [Task]) -> Bool {
        tasks.isEmpty
    }
    
    func delete(_ task: Task, modelContext: ModelContext) throws {
        let actions = TaskActions(modelContext: modelContext)
        
        try actions.deleteTask(task)
    }
    
    func reactivate(_ task: Task, modelContext: ModelContext) throws {
        let actions = TaskActions(modelContext: modelContext)
        
        try actions.reactivateTask(task)
    }
    
    func sortedTasks(tasks: [Task]) -> [Task] {
        return tasks.sorted {lhs, rhs in
            lhs.completedAt! > rhs.completedAt!
        }
    }
}
