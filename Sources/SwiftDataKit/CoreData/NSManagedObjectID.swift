//
//  NSManagedObjectID.swift
//
//
//  Created by Yang Xu on 2023/8/23.
//

import CoreData
import Foundation
import SwiftData

public extension NSManagedObjectID {
    // Compute PersistentIdentifier from NSManagedObjectID
    var persistentIdentifier: PersistentIdentifier? {
        guard let storeIdentifier, let entityName else { return nil }
        let json = PersistentIdentifierJSON(
            implementation: .init(primaryKey: primaryKey,
                                  uriRepresentation: uriRepresentation(),
                                  isTemporary: isTemporaryID,
                                  storeIdentifier: storeIdentifier,
                                  entityName: entityName)
        )
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(json) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(PersistentIdentifier.self, from: data)
    }
}

// Extensions to expose needed implementation details
extension NSManagedObjectID {
    // Primary key is last path component of URI
    var primaryKey: String {
        uriRepresentation().lastPathComponent
    }

    // Store identifier is host of URI
    var storeIdentifier: String? {
        guard let identifier = uriRepresentation().host() else { return nil }
        return identifier
    }

    // Entity name from entity name
    var entityName: String? {
        guard let entityName = entity.name else { return nil }
        return entityName
    }
}

// Model to represent identifier implementation as JSON
struct PersistentIdentifierJSON: Codable {
    struct Implementation: Codable {
        var primaryKey: String
        var uriRepresentation: URL
        var isTemporary: Bool
        var storeIdentifier: String
        var entityName: String
    }

    var implementation: Implementation
}
