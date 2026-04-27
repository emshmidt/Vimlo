import XCTest
@testable import Vimlo

@MainActor
final class TaskHomeViewModelTests: XCTestCase {
    func testMakeSections_groupsTasksIntoOverdueTodayUpcomingAndNoDate() throws {
        let viewModel = TaskHomeViewModel()
        let calendar = viewModel.calendar
        let today = calendar.startOfDay(for: .now)
        let overdueDate = try XCTUnwrap(calendar.date(byAdding: .day, value: -1, to: today))
        let upcomingDate = try XCTUnwrap(calendar.date(byAdding: .day, value: 1, to: today))

        let overdueTask = makeTask(title: "Overdue", dueDate: overdueDate)
        let todayTask = makeTask(title: "Today", dueDate: today)
        let upcomingTask = makeTask(title: "Upcoming", dueDate: upcomingDate)
        let noDateTask = makeTask(title: "No Date", dueDate: nil)

        let sections = viewModel.makeSections(tasks: [
            noDateTask,
            upcomingTask,
            todayTask,
            overdueTask,
        ])

        XCTAssertEqual(sections.map(\.type), [.overdue, .today, .upcoming, .noDate])
        XCTAssertEqual(sections[0].tasks.map(\.title), ["Overdue"])
        XCTAssertEqual(sections[1].tasks.map(\.title), ["Today"])
        XCTAssertEqual(sections[2].tasks.map(\.title), ["Upcoming"])
        XCTAssertEqual(sections[3].tasks.map(\.title), ["No Date"])
    }

    private func makeTask(title: String, dueDate: Date?) -> Task {
        let createdAt = Date(timeIntervalSince1970: 100)

        return Task(
            title: title,
            note: nil,
            dueDate: dueDate,
            isCompleted: false,
            createdAt: createdAt,
            updatedAt: createdAt,
            completedAt: nil
        )
    }
}
