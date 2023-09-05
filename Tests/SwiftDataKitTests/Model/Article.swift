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
    var category: Category?
    @Relationship(deleteRule: .nullify)
    var collection: ArticleCollection?
    init(name: String, category: Category? = nil, collection: ArticleCollection? = nil) {
        self.name = name
        self.category = category
        self.collection = collection
    }
}

@Model
class Category {
    var name: String
    @Relationship(deleteRule: .nullify)
    var articles: [Article]
    init(name: String, articles: [Article] = []) {
        self.name = name
        self.articles = articles
    }

    enum Name: String, CaseIterable {
        case tech, health, travel
    }
}

@ModelActor
actor ArticleHandler {
    func dataGenerator(collectionCount: Int = 20, articleCount: Int = 100, categoryNames: [String] = Category.Name.allCases.map(\.rawValue)) throws {
        // create category
        var categories = [Category]()
        for categoryName in categoryNames {
            let category = Category(name: categoryName)
            modelContext.insert(category)
            categories.append(category)
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
            article.category = categories.randomElement()!
            modelContext.insert(article)
        }

        try modelContext.save()
    }

    func getCollectCountByTagByKit(categoryName: String) -> Int {
        guard let category = getCategory(by: categoryName) else {
            fatalError("Can't get tag by name:\(categoryName)")
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticleCollection")
        let predicate = NSPredicate(format: "SUBQUERY(articles,$article,$article.category == %@).@count > 0", category.managedObject)
        fetchRequest.predicate = predicate
        return (try? modelContext.managedObjectContext?.count(for: fetchRequest)) ?? 0
    }

    func getCollectPersistentIdentifiersByTagByKit(categoryName: String) -> [PersistentIdentifier] {
        guard let category = getCategory(by: categoryName) else {
            fatalError("Can't get tag by name:\(categoryName)")
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArticleCollection")
        let predicate = NSPredicate(format: "SUBQUERY(articles,$article,$article.category == %@).@count > 0", category.managedObject)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [.init(key: "name", ascending: true)]
        let collections = (try? modelContext.managedObjectContext?.fetch(fetchRequest)) ?? []
        return collections.compactMap(\.objectID.persistentIdentifier)
    }

    func getCollectNamesByTagByKit(categoryName: String) -> [String] {
        guard let category = getCategory(by: categoryName) else {
            fatalError("Can't get tag by name:\(categoryName)")
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ArticleCollection")
        let predicate = NSPredicate(format: "SUBQUERY(articles,$article,$article.category == %@).@count > 0", category.managedObject)

        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [.init(key: "name", ascending: true)]
        let collections = (try? modelContext.managedObjectContext?.fetch(fetchRequest)) ?? []
        return collections.map { $0.value(forKey: "name") as! String }
    }

    func getCollectCountByTagByQuery(categoryName: String) -> Int {
        guard let category = getCategory(by: categoryName) else {
            fatalError("Can't get tag by name:\(categoryName)")
        }
        let description = FetchDescriptor<ArticleCollection>()
        let collections = (try? modelContext.fetch(description)) ?? []
        let count = collections.filter { collection in
            !(collection.articles).filter { article in
                article.category == category
            }.isEmpty
        }.count
        return count
    }

    func getCategory(by name: String) -> Category? {
        let predicate = #Predicate<Category> {
            $0.name == name
        }
        let categoryDescription = FetchDescriptor<Category>(predicate: predicate)
        return try? modelContext.fetch(categoryDescription).first
    }

    func reset() {
        modelContext.managedObjectContext?.reset()
    }

    func convertIdentifierToModel<T: PersistentModel>(ids: [PersistentIdentifier], type: T.Type) -> [T] {
        ids.compactMap { self[$0, as: type] }
    }
}
