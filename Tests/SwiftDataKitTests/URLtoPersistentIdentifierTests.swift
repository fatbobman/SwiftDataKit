//
//  File.swift
//
//
//  Created by Yang Xu on 2023/9/5.
//

import Foundation
import SwiftData
@testable import SwiftDataKit
import XCTest

@MainActor
class URLtoPersistentIdentifierTests: XCTestCase {
    func testURLtoPersistentIdentifier() async throws {
        let container = try ModelContainer(for: Student.self, configurations: .init(isStoredInMemoryOnly: true))
        let hander = StudentHandler(modelContainer: container)
        let student = try await hander.createNewStudent()
        guard let identifier = student.persistentModelID.uriRepresentation?.persistentIdentifier else {
            XCTFail("Failed to get persistent identifier")
            return
        }
        XCTAssertEqual(student.persistentModelID, identifier)
    }
}

extension StudentHandler {
    func createNewStudent(name: String = "fat", birthOfYear: Int = 2000) throws -> Student {
        let student = Student(name: name, birthOfYear: birthOfYear)
        modelContext.insert(student)
        try! modelContext.save()
        return student
    }
}
