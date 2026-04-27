//
//  TaskActions.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 27.04.2026.
//

import Foundation
import SwiftData

struct TaskActions {
    var modelContext: ModelContext
    var calendar: Calendar
    
    init(modelContext: ModelContext, calendar: Calendar = .current) {
        self.modelContext = modelContext
        self.calendar = calendar
    }
    
    
    func deleteTask(_ task: Task) throws {
        modelContext.delete(task)
        try modelContext.save()
    }
    
    func completeTask(_ task: Task) throws {
        task.isCompleted = true
        task.completedAt = .now
        task.updatedAt = .now
        
        try modelContext.save()
    }
    
    func reactivateTask(_ task: Task) throws {
        task.isCompleted = false
        task.completedAt = nil
        task.updatedAt = .now
        
        try modelContext.save()
    }
    
}
