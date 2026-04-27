import SwiftData
import XCTest
@testable import Vimlo

@MainActor
final class TaskActionsTests: XCTestCase {
    func testCompleteTask_setsCompletedStateAndTimestamps() throws {
        let container = try SwiftDataTestContainer.makeInMemoryContainer()
        let context = ModelContext(container)
        let originalTimestamp = Date(timeIntervalSince1970: 100)
        let task = Task(
            title: "Buy milk",
            note: nil,
            dueDate: nil,
            isCompleted: false,
            createdAt: originalTimestamp,
            updatedAt: originalTimestamp,
            completedAt: nil
        )

        context.insert(task)
        try context.save()

        let actions = TaskActions(modelContext: context)
        try actions.completeTask(task)

        XCTAssertTrue(task.isCompleted)
        XCTAssertNotNil(task.completedAt)
        XCTAssertGreaterThanOrEqual(task.updatedAt, originalTimestamp)

        let storedTask = try XCTUnwrap(try SwiftDataTestContainer.fetchAllTasks(in: context).first)
        XCTAssertTrue(storedTask.isCompleted)
        XCTAssertNotNil(storedTask.completedAt)
    }
}
