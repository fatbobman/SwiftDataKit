//
//  Models.swift
//
//
//  Created by Yang Xu on 2023/9/4.
//

import CoreData
import Foundation
import SwiftData

@Model
class Student {
    var name: String
    var birthOfYear: Int

    init(name: String, birthOfYear: Int) {
        self.name = name
        self.birthOfYear = birthOfYear
    }
}

@ModelActor
actor StudentHandler {
    func dataGenerator(count: Int = 100) throws {
        for i in 0 ..< count {
            let student = Student(name: "\(i)", birthOfYear: [2000, 2001, 2002, 2003, 2004, 2005].randomElement()!)
            modelContext.insert(student)
            try modelContext.save()
        }
    }

    func birthYearCountByKit() -> [Int: Int] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        fetchRequest.propertiesToGroupBy = ["birthOfYear"]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "birthOfYear", ascending: true)]
        fetchRequest.resultType = .dictionaryResultType
        let expressDescription = NSExpressionDescription()
        expressDescription.resultType = .integer64
        expressDescription.name = "count"
        let year = NSExpression(forKeyPath: "birthOfYear")
        let express = NSExpression(forFunction: "count:", arguments: [year])
        expressDescription.expression = express
        fetchRequest.propertiesToFetch = ["birthOfYear", expressDescription]
        let fetchResult = (try? modelContext.managedObjectContext.fetch(fetchRequest) as? [[String: Any]]) ?? []
        let result: [Int: Int] = fetchResult.reduce(into: [:]) { result, element in
            result[element["birthOfYear"] as! Int] = (element["count"] as! Int?) ?? 0
        }
        return result
    }

    func birthYearCountByQuery() -> [Int: Int] {
        let description = FetchDescriptor<Student>(sortBy: [.init(\Student.birthOfYear, order: .forward)])
        let students = (try? modelContext.fetch(description)) ?? []
        let result: [Int: Int] = students.reduce(into: [:]) { result, student in
            let count = result[student.birthOfYear, default: 0]
            result[student.birthOfYear] = count + 1
        }
        return result
    }
}

@Model
class ArticleCollection {
    var name: String
    @Relationship(deleteRule: .nullify)
    var articles: [Article]
    init(name: String, articles: [Article] = []) {
        self.name = name
        self.articles = articles
    }
}

@Model
class Article {
    var name: String
    @Relationship(deleteRule: .nullify)
    var tags: [Tag]
    @Relationship(deleteRule: .nullify)
    var collection: ArticleCollection?
    init(name: String, tags: [Tag] = [], collection: ArticleCollection? = nil) {
        self.name = name
        self.tags = tags
        self.collection = collection
    }
}

@Model
class Tag {
    var name: String
    @Relationship(deleteRule: .nullify)
    var articles: [Article]
    init(name: String, articles: [Article] = []) {
        self.name = name
        self.articles = articles
    }
}

@ModelActor
actor ArticleHandler {
    func dataGenerator(collectionCount: Int = 20, articleCount: Int = 100, tagNames: [String] = ["tech", "health", "travel"]) {
        // create tags
        var tags = [Tag]()
        for tagName in tagNames {
            let tag = Tag(name: tagName)
            modelContext.insert(tag)
            tags.append(tag)
        }

        // create collections
        var collections = [ArticleCollection]()
        for i in 0 ..< collectionCount {
            let collection = ArticleCollection(name: "c\(i)")
            modelContext.insert(collection)
            collections.append(collection)
        }

        // create article
        for i in 0 ..< articleCount {
            let article = Article(name: "a\(i)")
            article.collection = collections.randomElement()!
            let tags = tags.shuffled()
            for n in 0 ..< Int.random(in: 0 ..< tags.count) {
                article.tags.append(tags[n])
            }
            modelContext.insert(article)
        }
    }

    func getCollectCountByTagByKit(tagName: String) -> Int {
        guard let tag = getTag(by: tagName) else {
            fatalError("Can't get tag by name:\(tagName)")
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleCollection")
        let predicate = NSPredicate(format: "SUBQUERY(articles,$article, %@ IN $article.tags).@count > 0", tag.managedObject)
        fetchRequest.predicate = predicate
        return (try? modelContext.managedObjectContext.count(for: fetchRequest)) ?? 0
    }

    func getCollectCountByTagByQuery(tagName: String) -> Int {
        guard let tag = getTag(by: tagName) else {
            fatalError("Can't get tag by name:\(tagName)")
        }
        let description = FetchDescriptor<ArticleCollection>()
        let collections = (try? modelContext.fetch(description)) ?? []
        let count = collections.filter { collection in
            !(collection.articles).filter { article in
                article.tags.contains(tag)
            }.isEmpty
        }.count
        return count
    }

    func getTag(by name: String) -> Tag? {
        let predicate = #Predicate<Tag> {
            $0.name == name
        }
        let tagDescription = FetchDescriptor<Tag>(predicate: predicate)
        return try? modelContext.fetch(tagDescription).first
    }
}
