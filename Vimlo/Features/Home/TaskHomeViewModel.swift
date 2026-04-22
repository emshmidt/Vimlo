//
//  TaskHomeViewModel.swift
//  Vimlo
//
//  Created by Эмилия Шмидт on 07.04.2026.
//

import Foundation

enum TaskType: String, CaseIterable {
    case overdue
    case today
    case upcoming
    case noDate
}

struct SectionModel: Identifiable {
    let type: TaskType
    var tasks: [Task] = [Task]()
    
    var id: TaskType {type}
    
    var title: String {
        switch type {
        case .today: return "Today"
        case .upcoming: return "Upcoming"
        case .overdue: return "Overdue"
        case .noDate: return "No Date"
        }
    }
    
    init(type: TaskType, tasks: [Task]) {
        self.type = type
        self.tasks = tasks
    }
    
    
}

@Observable
class TaskHomeViewModel {
    var isAddTaskSheetPresented = false
    var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    var orderedTypes: [TaskType] = [.overdue, .today, .upcoming, .noDate]
    
    private func getTaskBucket(task: Task, referenceToday: Date) -> TaskType {
        guard let dueDate = task.dueDate else { return .noDate }
        let normalizedDueDate = calendar.startOfDay(for: dueDate)
        
        if normalizedDueDate == referenceToday {
            return .today
        } else if normalizedDueDate > referenceToday {
            return .upcoming
        } else {
            return .overdue
        }
    }
    
    private func makeGroups(tasks: [Task], referenceToday: Date) -> [TaskType: [Task]]{
        var newGroups: [TaskType: [Task]] = [:]
        
        for task in tasks {
            let bucket = getTaskBucket(task: task, referenceToday: referenceToday)
            newGroups[bucket, default: []].append(task)
        }
        
        var sortedGroups: [TaskType: [Task]] = [:]
        
        for (bucket, buckettasks) in newGroups {
            if bucket == .overdue || bucket == .upcoming {
                sortedGroups[bucket] = sortWithDueDatePriority(tasks: buckettasks)
            } else {
                sortedGroups[bucket] = sortByCreationDate(tasks: buckettasks)
            }
        }
        
        return sortedGroups
    }
    
    func makeSections(tasks: [Task]) -> [SectionModel] {
        var newSections: [SectionModel] = []
        let today = calendar.startOfDay(for: Date.now)
        let groupedTasks = makeGroups(tasks: tasks, referenceToday: today)
        
        for type in orderedTypes {
            guard let tasks = groupedTasks[type] else { continue }
            if tasks.isEmpty { continue }
            newSections.append(SectionModel(type: type, tasks: groupedTasks[type]!))
        }
        
        return newSections
    }
    
    private func sortWithDueDatePriority(tasks: [Task]) -> [Task] {
        tasks.sorted { lhs, rhs in
            guard let lhsDueDate = lhs.dueDate, let rhsDueDate = rhs.dueDate else { return lhs.createdAt < rhs.createdAt }
            
            if lhsDueDate == rhsDueDate {
                return lhs.createdAt < rhs.createdAt
            }
            
            return lhsDueDate < rhsDueDate
        }
    }
    
    private func sortByCreationDate(tasks: [Task]) -> [Task] {
        tasks.sorted {$0.createdAt < $1.createdAt}
    }
    
    func tappedPlusButton() {
        isAddTaskSheetPresented = true
    }
    
    func isEmpty(tasks: [Task]) -> Bool {
        tasks.isEmpty
    }
    
    func didDismissCreateSheet() {
        isAddTaskSheetPresented = false
    }
}
