import SwiftData
@testable import Vimlo

enum SwiftDataTestContainer {
    static func makeInMemoryContainer() throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: Task.self, configurations: configuration)
    }

    static func fetchAllTasks(in context: ModelContext) throws -> [Task] {
        try context.fetch(FetchDescriptor<Task>())
    }
}
