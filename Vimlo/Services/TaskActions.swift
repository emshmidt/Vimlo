//
//  TaskActions.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import Foundation
import SwiftData

@MainActor
struct TaskActions {
    let modelContext: ModelContext
    let calendar: Calendar

    init(modelContext: ModelContext, calendar: Calendar = .current) {
        self.modelContext = modelContext
        self.calendar = calendar
    }

    @discardableResult
    func createTask(from draft: TaskDraft) throws -> Task {
        let task = Task(title: draft.trimmedTitle)
        applyDraft(draft, to: task)
        modelContext.insert(task)
        try modelContext.save()
        return task
    }

    func updateTask(_ task: Task, with draft: TaskDraft) throws {
        applyDraft(draft, to: task)
        try modelContext.save()
    }

    func completeTask(_ task: Task, with draft: TaskDraft? = nil) throws {
        if let draft {
            applyDraft(draft, to: task)
        }

        task.isCompleted = true
        task.completedAt = .now
        task.updatedAt = .now
        try modelContext.save()
    }

    func deleteTask(_ task: Task) throws {
        modelContext.delete(task)
        try modelContext.save()
    }

    private func applyDraft(_ draft: TaskDraft, to task: Task) {
        task.title = draft.trimmedTitle
        task.note = draft.trimmedNote.isEmpty ? nil : draft.trimmedNote
        task.dueDate = draft.hasDueDate
            ? calendar.startOfDay(for: draft.dueDate)
            : nil
        task.updatedAt = .now
    }
}
