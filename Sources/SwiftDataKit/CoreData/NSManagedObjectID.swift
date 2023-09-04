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
    var persistentIdentifier: PersistentIdentifier {
        let json = PersistentIdentifierJSON(
            implementation: .init(primaryKey: primaryKey,
                                  uriRepresentation: uriRepresentation(),
                                  isTemporary: isTemporaryID,
                                  storeIdentifier: storeIdentifier,
                                  entityName: entityName)
        )
        let encoder = JSONEncoder()
        let data = try! encoder.encode(json)
        let decoder = JSONDecoder()
        return try! decoder.decode(PersistentIdentifier.self, from: data)
    }
}

extension NSManagedObjectID {
    var primaryKey: String {
        uriRepresentation().lastPathComponent
    }

    var storeIdentifier: String {
        guard let identifier = uriRepresentation().host() else {
            fatalError("\(#file) \(#line) Can't get storeIdentifier from ManagedObjectID:\(self)")
        }
        return identifier
    }

    var entityName: String {
        guard let entityName = entity.name else {
            fatalError("\(#file) \(#line) Can't get entity name from ManagedObjectID:\(self)")
        }
        return entityName
    }
}

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
