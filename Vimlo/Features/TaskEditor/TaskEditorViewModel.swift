//
//  TaskEditorViewModel.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 09.04.2026.
//

import Foundation
import SwiftData
import SwiftUI

enum Mode {
    case create
    case edit
}

@Observable
class TaskEditorViewModel {
    var title: String {
        if mode == .create {
            return "Create task"
        }
        
        return "Edit task"
    }
    var saveTitle: String {
        if mode == .create {
            return "Create"
        }
        
        return "Save"
    }
    let mode: Mode
    var taskDraft: TaskDraft
    var editingTask: Task?
    var isDeletePresented = false
    
    init() {
        self.mode = .create
        self.taskDraft = .empty()
        self.editingTask = nil
    }
    
    init(task: Task) {
        self.mode = .edit
        self.taskDraft = .fromTask(task: task)
        self.editingTask = task
    }
    
    func save(context: ModelContext) throws {
        let task = transformTaskDraft(from: taskDraft)
        if mode == .create {
            context.insert(task)
        } else {
            editingTask?.title = task.title
            editingTask?.note = task.note
            editingTask?.dueDate = task.dueDate
            editingTask?.isCompleted = task.isCompleted
            editingTask?.updatedAt = Date.now
            editingTask?.completedAt = task.completedAt
        }
        try context.save()
    }
    
    func deleteTapped() {
        isDeletePresented = true
    }
    
    func delete(context: ModelContext) throws {
        let actions = TaskActions(modelContext: context)
        
        guard let task = editingTask else { return }
        try actions.deleteTask(task)
    }
    
    func onToggleCompletion() {
        taskDraft.isCompleted.toggle()
        if taskDraft.isCompleted {
            taskDraft.completedAt = .now
        } else {
            taskDraft.completedAt = nil
        }
    }
    
    func transformTaskDraft(from taskDraft: TaskDraft) -> Task {
        Task(
            title: taskDraft.trimmedTitle,
            note: taskDraft.trimmedNote,
            dueDate: taskDraft.normalizedDueDate ?? nil,
            isCompleted: taskDraft.isCompleted,
            createdAt: Date.now,
            updatedAt: Date.now,
            completedAt: taskDraft.completedAt
        )
    }
    
}
