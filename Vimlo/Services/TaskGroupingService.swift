//
//  TaskGroupingService.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import Foundation

enum TaskBucket: String, CaseIterable, Identifiable {
    case overdue
    case today
    case upcoming
    case noDate

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overdue:
            "Overdue"
        case .today:
            "Today"
        case .upcoming:
            "Upcoming"
        case .noDate:
            "No Date"
        }
    }
}

struct TaskSectionModel: Identifiable {
    let bucket: TaskBucket
    let tasks: [Task]

    var id: TaskBucket { bucket }
    var title: String { bucket.title }
}

struct TaskGroupingService {
    let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func makeSections(from tasks: [Task], now: Date = .now) -> [TaskSectionModel] {
        let activeTasks = tasks.filter { !$0.isCompleted }
        let groupedTasks = Dictionary(grouping: activeTasks) { task in
            bucket(for: task, now: now)
        }

        return TaskBucket.allCases.compactMap { bucket in
            guard let tasksInBucket = groupedTasks[bucket], !tasksInBucket.isEmpty else {
                return nil
            }

            return TaskSectionModel(
                bucket: bucket,
                tasks: sortTasks(tasksInBucket, in: bucket)
            )
        }
    }

    func bucket(for task: Task, now: Date = .now) -> TaskBucket {
        guard let dueDate = task.dueDate else {
            return .noDate
        }

        if calendar.isDate(dueDate, inSameDayAs: now) {
            return .today
        }

        let dueDay = calendar.startOfDay(for: dueDate)
        let today = calendar.startOfDay(for: now)

        if dueDay < today {
            return .overdue
        }

        return .upcoming
    }

    func sortTasks(_ tasks: [Task], in bucket: TaskBucket) -> [Task] {
        tasks.sorted { lhs, rhs in
            switch bucket {
            case .overdue, .upcoming:
                return compareByDueDateThenCreatedAt(lhs, rhs)

            case .today, .noDate:
                return lhs.createdAt < rhs.createdAt
            }
        }
    }

    private func compareByDueDateThenCreatedAt(_ lhs: Task, _ rhs: Task) -> Bool {
        switch (lhs.dueDate, rhs.dueDate) {
        case let (lhsDue?, rhsDue?) where lhsDue != rhsDue:
            return lhsDue < rhsDue
        default:
            return lhs.createdAt < rhs.createdAt
        }
    }
}
