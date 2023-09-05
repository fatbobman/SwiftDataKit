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
    func testArticle() async throws {
        let container = try ModelContainer(for: ArticleCollection.self, Article.self, Tag.self, configurations: .init(isStoredInMemoryOnly: true))
        let handler = ArticleHandler(modelContainer: container)
        await handler.dataGenerator()
        let countByKit = await handler.getCollectCountByTagByKit(tagName: "tech")
        let countByQuery = await handler.getCollectCountByTagByQuery(tagName: "tech")
        XCTAssertEqual(countByKit, countByQuery)
    }
}
