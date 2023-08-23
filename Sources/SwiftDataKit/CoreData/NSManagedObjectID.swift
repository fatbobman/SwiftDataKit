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
        uriRepresentation().host()!
    }

    var entityName: String {
        entity.name!
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
