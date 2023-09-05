//
//  Article.swift
//
//
//  Created by Yang Xu on 2023/9/5.
//

import CoreData
import Foundation
import SwiftData

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

