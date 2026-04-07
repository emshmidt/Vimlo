//
//  TaskDraft.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import Foundation

struct TaskDraft {
    var title: String
    var note: String
    var hasDueDate: Bool
    var dueDate: Date

    init(task: Task? = nil, calendar: Calendar = .current) {
        self.title = task?.title ?? ""
        self.note = task?.note ?? ""
        self.hasDueDate = task?.dueDate != nil
        self.dueDate = task?.dueDate ?? calendar.startOfDay(for: .now)
    }

    var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedNote: String {
        note.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isSaveEnabled: Bool {
        !trimmedTitle.isEmpty
    }
}
