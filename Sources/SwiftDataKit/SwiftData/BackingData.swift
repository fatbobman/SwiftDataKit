//
//  BackingData.swift
//
//
//  Created by Yang Xu on 2023/9/20.
//

import CoreData
import Foundation
import SwiftData

public extension BackingData {
    // Computed property to access the NSManagedObject
    var managedObject: NSManagedObject? {
        guard let object = getMirrorChildValue(of: self, childName: "_managedObject") as? NSManagedObject else {
            return nil
        }
        return object
    }

    // Computed property to access the NSManagedObjectContext
    var managedObjectContext: NSManagedObjectContext? {
        guard let object = getMirrorChildValue(of: self, childName: "_nsContext") as? NSManagedObjectContext else {
            return nil
        }
        return object
    }
}
