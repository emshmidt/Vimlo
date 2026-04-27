import XCTest
@testable import Vimlo

@MainActor
final class TaskDraftTests: XCTestCase {
    func testIsSaveEnabled_returnsFalseForWhitespaceOnlyTitle() {
        let draft = TaskDraft(
            title: "  \n\t  ",
            note: "",
            hasDueDate: false,
            dueDate: nil,
            isCompleted: false,
            completedAt: nil
        )

        XCTAssertFalse(draft.isSaveEnabled)
    }

    func testNormalizedDueDate_returnsStartOfDayWhenDueDateIsEnabled() throws {
        let calendar = Calendar.current
        let dueDate = try XCTUnwrap(
            calendar.date(bySettingHour: 15, minute: 45, second: 0, of: Date.now)
        )
        let draft = TaskDraft(
            title: "Read chapter 3",
            note: "",
            hasDueDate: true,
            dueDate: dueDate,
            isCompleted: false,
            completedAt: nil
        )

        XCTAssertEqual(draft.normalizedDueDate, calendar.startOfDay(for: dueDate))
    }
}
