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
    
    init(mode: Mode = .create) {
        self.mode = mode
        
        switch mode {
        case .create:
            self.taskDraft = .empty()
        case .edit:
            self.taskDraft = .empty() // потом замените на init(from: task)
        }
    }
    
    func save(context: ModelContext) throws {
        let task = transformTaskDraft(from: taskDraft)
        context.insert(task)
        try context.save()
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
