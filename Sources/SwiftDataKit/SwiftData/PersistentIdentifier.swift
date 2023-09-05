//
//  PersistentIdentifier.swift
//
//
//  Created by Yang Xu on 2023/8/23.
//

import CoreData
import Foundation
import SwiftData

// Extension to add computed properties for accessing underlying CoreData
// implementation details of PersistentIdentifier
public extension PersistentIdentifier {
    // Private stored property to hold reference to underlying implementation
    private var _implementation: Any {
        guard let implementation = getMirrorChildValue(of: self, childName: "implementation") else {
            fatalError("\(#file) \(#line) Can't get implementation from PersistentObjectID:\(self)")
        }
        return implementation
    }

    // Computed property to access managedObjectID from implementation
    var objectID: NSManagedObjectID {
        guard let objectID = getMirrorChildValue(of: _implementation, childName: "managedObjectID") as? NSManagedObjectID else {
            fatalError("\(#file) \(#line) Can't get implementation from PersistentObjectID:\(self)")
        }
        return objectID
    }

    // Computed property to access uriRepresentation from objectID
    var uriRepresentation: URL {
        objectID.uriRepresentation()
    }

    // Computed property to access isTemporary from implementation
    var isTemporary: Bool {
        guard let isTemporary = getMirrorChildValue(of: _implementation, childName: "isTemporary") as? Bool else {
            fatalError("\(#file) \(#line) Can't get implementation from PersistentObjectID:\(self)")
        }
        return isTemporary
    }
}
