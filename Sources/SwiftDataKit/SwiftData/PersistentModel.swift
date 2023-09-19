//
//  PersistentModel.swift
//
//
//  Created by Yang Xu on 2023/8/23.
//

import CoreData
import Foundation
import SwiftData

/// Extension for `PersistentModel` that provides a computed property `managedObject` to access the underlying `NSManagedObject`.
public extension PersistentModel {
    /// Returns the `NSManagedObject` associated with the `PersistentModel`.
    ///
    /// - Returns: The `NSManagedObject?` instance.
    var managedObject: NSManagedObject? {
        persistentBackingData.managedObject
    }
}
