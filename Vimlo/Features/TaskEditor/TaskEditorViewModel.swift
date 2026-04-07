//
//  TaskEditorViewModel.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class TaskEditorViewModel {
    enum Mode {
        case create
        case edit(Task)
    }

    let mode: Mode
    var draft: TaskDraft

    private let calendar: Calendar

    init(task: Task? = nil, calendar: Calendar = .current) {
        if let task {
            self.mode = .edit(task)
        } else {
            self.mode = .create
        }

        self.draft = TaskDraft(task: task, calendar: calendar)
        self.calendar = calendar
    }

    var navigationTitle: String {
        switch mode {
        case .create: "New Task"
        case .edit: "Edit Task"
        }
    }

    var saveTitle: String {
        switch mode {
        case .create: "Create"
        case .edit: "Save"
        }
    }

    var isSaveEnabled: Bool {
        draft.isSaveEnabled
    }

    var canDelete: Bool {
        if case .edit = mode { return true }
        return false
    }

    var canComplete: Bool {
        guard case let .edit(task) = mode else {
            return false
        }

        return !task.isCompleted
    }

    func save(in modelContext: ModelContext) throws {
        let actions = TaskActions(modelContext: modelContext, calendar: calendar)

        switch mode {
        case .create:
            try actions.createTask(from: draft)

        case .edit(let task):
            try actions.updateTask(task, with: draft)
        }
    }

    func delete(in modelContext: ModelContext) throws {
        let actions = TaskActions(modelContext: modelContext, calendar: calendar)

        guard case .edit(let task) = mode else { return }
        try actions.deleteTask(task)
    }

    func complete(in modelContext: ModelContext) throws {
        let actions = TaskActions(modelContext: modelContext, calendar: calendar)

        guard case .edit(let task) = mode else { return }
        try actions.completeTask(task, with: draft)
    }
}
