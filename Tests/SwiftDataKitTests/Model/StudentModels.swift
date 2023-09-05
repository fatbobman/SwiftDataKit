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
        let fetchResult = (try? modelContext.managedObjectContext?.fetch(fetchRequest) as? [[String: Any]]) ?? []
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
    
    func reset() {
        modelContext.managedObjectContext?.reset()
    }
}

