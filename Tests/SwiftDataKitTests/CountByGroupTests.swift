import SwiftData
@testable import SwiftDataKit
import XCTest

final class CountByGroupTests: XCTestCase {
    func testCountByGroup() async throws {
        let container = try ModelContainer(for: Student.self, configurations: .init(isStoredInMemoryOnly: true))
        let hander = StudentHandler(modelContainer: container)
        try await hander.dataGenerator()
        let kitResult = await hander.birthYearCountByKit()
        let queryResult = await hander.birthYearCountByQuery()
        XCTAssertEqual(kitResult, queryResult)
    }

    func testCountByKitPerformance() async throws {
        let container = try ModelContainer(for: Student.self, configurations: .init(isStoredInMemoryOnly: true))
        let hander = StudentHandler(modelContainer: container)
        try await hander.dataGenerator(count: 10000)
        measureAsync(timeout: 2) {
            let _ = await hander.birthYearCountByKit()
        }
    }

    func testCountByQueryPerformance() async throws {
        let container = try ModelContainer(for: Student.self, configurations: .init(isStoredInMemoryOnly: true))
        let hander = StudentHandler(modelContainer: container)
        try await hander.dataGenerator(count: 10000)
        measureAsync(timeout: 2) {
            let _ = await hander.birthYearCountByQuery()
        }
    }
}
