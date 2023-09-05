//
//  File.swift
//
//
//  Created by Yang Xu on 2023/8/23.
//

import CoreData
import Foundation
import SwiftData

// Extension to add computed properties for accessing underlying CoreData implementation details
public extension ModelContext {
    // Computed property to access the underlying NSManagedObjectContext
    var managedObjectContext: NSManagedObjectContext {
        guard let managedObjectContext = getMirrorChildValue(of: self, childName: "_nsContext") as? NSManagedObjectContext else {
            fatalError("\(#file) \(#line) Can't get NSManagedObjectContext from ModelContext:\(self)")
        }
        return managedObjectContext
    }

    // Computed property to access the NSPersistentStoreCoordinator
    var coordinator: NSPersistentStoreCoordinator? {
        managedObjectContext.persistentStoreCoordinator
    }
}
