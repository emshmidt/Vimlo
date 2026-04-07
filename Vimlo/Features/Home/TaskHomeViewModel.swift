//
//  TaskHomeViewModel.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class TaskHomeViewModel {
    var isPresentingCreateSheet = false

    private let groupingService: TaskGroupingService

    init(groupingService: TaskGroupingService = TaskGroupingService()) {
        self.groupingService = groupingService
    }

    func sections(for tasks: [Task], now: Date = .now) -> [TaskSectionModel] {
        groupingService.makeSections(from: tasks, now: now)
    }

    func isEmpty(tasks: [Task]) -> Bool {
        tasks.isEmpty
    }

    func didTapAddTask() {
        isPresentingCreateSheet = true
    }

    func didDismissCreateSheet() {
        isPresentingCreateSheet = false
    }

    func delete(_ task: Task, in modelContext: ModelContext) throws {
        let actions = TaskActions(modelContext: modelContext)
        try actions.deleteTask(task)
    }

    func complete(_ task: Task, in modelContext: ModelContext) throws {
        let actions = TaskActions(modelContext: modelContext)
        try actions.completeTask(task)
    }
}
