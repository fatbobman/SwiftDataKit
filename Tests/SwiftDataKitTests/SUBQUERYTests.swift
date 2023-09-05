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

class SUBQUERYTests: XCTestCase {
    func testSubQueryByKit() async throws {
        let container = try ModelContainer(for: ArticleCollection.self, Article.self, Tag.self, configurations: .init(isStoredInMemoryOnly: true))
        let handler = ArticleHandler(modelContainer: container)
        try await handler.dataGenerator()
        let countByKit = await handler.getCollectCountByTagByKit(tagName: "tech")
        let countByQuery = await handler.getCollectCountByTagByQuery(tagName: "tech")
        XCTAssertEqual(countByKit, countByQuery)
    }

    func testSubQueryByKitPerformance() async throws {
        let container = try ModelContainer(for: ArticleCollection.self, Article.self, Tag.self, configurations: .init(isStoredInMemoryOnly: true))
        let handler = ArticleHandler(modelContainer: container)
        try await handler.dataGenerator(collectionCount: 300, articleCount: 10000)
        await handler.reset()
        measureAsync(timeout: 10) {
            let _ = await handler.getCollectCountByTagByKit(tagName: "tech")
        }
    }

    func testSubQueryBySwiftDataPerformance() async throws {
        let container = try ModelContainer(for: ArticleCollection.self, Article.self, Tag.self, configurations: .init(isStoredInMemoryOnly: true))
        let handler = ArticleHandler(modelContainer: container)
        try await handler.dataGenerator(collectionCount: 300, articleCount: 10000)
        await handler.reset()
        measureAsync(timeout: 10) {
            let _ = await handler.getCollectCountByTagByQuery(tagName: "tech")
        }
    }
}
