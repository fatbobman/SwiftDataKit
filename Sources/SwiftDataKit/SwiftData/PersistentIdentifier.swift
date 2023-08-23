//
//  PersistentIdentifier.swift
//
//
//  Created by Yang Xu on 2023/8/23.
//

import CoreData
import Foundation
import SwiftData

public extension PersistentIdentifier {
    private var _implementation: Any {
        guard let implementation = getMirrorChildValue(of: self, childName: "implementation") else {
            fatalError("\(#file) \(#line) Can't get implementation from PersistentObjectID:\(self)")
        }
        return implementation
    }

    var objectID: NSManagedObjectID {
        guard let objectID = getMirrorChildValue(of: _implementation, childName: "managedObjectID") as? NSManagedObjectID else {
            fatalError("\(#file) \(#line) Can't get implementation from PersistentObjectID:\(self)")
        }
        return objectID
    }

    var uriRepresentation: URL {
        objectID.uriRepresentation()
    }

    var isTemporary: Bool {
        guard let isTemporary = getMirrorChildValue(of: _implementation, childName: "isTemporary") as? Bool else {
            fatalError("\(#file) \(#line) Can't get implementation from PersistentObjectID:\(self)")
        }
        return isTemporary
    }
}
