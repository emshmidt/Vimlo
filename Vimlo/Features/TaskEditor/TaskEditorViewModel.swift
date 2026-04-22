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

struct TaskDraft {
    var title: String
    var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var isSaveEnabled: Bool {
        !trimmedTitle.isEmpty
    }
    var note: String
    var hasDueDate: Bool
    var dueDate: Date?
    var normalizedDueDate: Date? {
        guard hasDueDate, let dueDate else { return nil }
        return Calendar.current.startOfDay(for: dueDate)
    }
    var trimmedNote: String? {
        note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil :
        note.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    //var isCompleted: Bool
    //var createdAt: Date
    //var updatedAt: Date
    //var completedAt: Date?
    
    static func empty() -> TaskDraft {
        TaskDraft(
            title: "",
            note: "",
            hasDueDate: false,
            dueDate: nil
        )
    }
    
    static func fromTask(task: Task) -> TaskDraft {
        TaskDraft(
            title: task.title,
            note: task.note ?? "",
            hasDueDate: task.dueDate != nil,
            dueDate: task.dueDate
        )
    }
}

@Observable
class TaskEditorViewModel {
    var title: String {
        if mode == .create {
            return "Create task"
        }
        
        return "Edit task"
    }
    let mode: Mode
    var taskDraft: TaskDraft
    var editingtask: Task?
    var isDeletePresented = false
    
    init() {
        self.mode = .create
        self.taskDraft = .empty()
        self.editingtask = nil
    }
    
    init(task: Task) {
        self.mode = .edit
        self.taskDraft = .fromTask(task: task)
        self.editingtask = task
    }
    
    func save(context: ModelContext) throws {
        let task = transformTaskDraft(from: taskDraft)
        if mode == .create {
            context.insert(task)
        } else {
            editingtask?.title = task.title
            editingtask?.note = task.note
            editingtask?.dueDate = task.dueDate
            editingtask?.updatedAt = Date.now
        }
        try context.save()
    }
    
    func deleteTapped() {
        isDeletePresented = true
    }
    
    func delete(context: ModelContext) throws {
        context.delete(editingtask!)
        try context.save()
        isDeletePresented = false
    }
    
    func transformTaskDraft(from taskDraft: TaskDraft) -> Task {
        Task(
            title: taskDraft.trimmedTitle,
            note: taskDraft.trimmedNote,
            dueDate: taskDraft.normalizedDueDate ?? nil,
            createdAt: Date.now,
            updatedAt: Date.now
        )
    }
    
}
