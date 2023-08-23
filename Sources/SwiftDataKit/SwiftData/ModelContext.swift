//
//  File.swift
//
//
//  Created by Yang Xu on 2023/8/23.
//

import CoreData
import Foundation
import SwiftData

public extension ModelContext {
    var managedObjectContext: NSManagedObjectContext {
        guard let managedObjectContext = getMirrorChildValue(of: self, childName: "_nsContext") as? NSManagedObjectContext else {
            fatalError("\(#file) \(#line) Can't get NSManagedObjectContext from ModelContext:\(self)")
        }
        return managedObjectContext
    }

    var coordinator: NSPersistentStoreCoordinator? {
        managedObjectContext.persistentStoreCoordinator
    }
}
