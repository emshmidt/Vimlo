//
//  TaskDraft.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 27.04.2026.
//

import Foundation

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
    var isCompleted: Bool
    var completedAt: Date?
    
    static func empty() -> TaskDraft {
        TaskDraft(
            title: "",
            note: "",
            hasDueDate: false,
            dueDate: nil,
            isCompleted: false,
            completedAt: nil
        )
    }
    
    static func fromTask(task: Task) -> TaskDraft {
        TaskDraft(
            title: task.title,
            note: task.note ?? "",
            hasDueDate: task.dueDate != nil,
            dueDate: task.dueDate,
            isCompleted: task.isCompleted,
            completedAt: task.completedAt
        )
    }
}
