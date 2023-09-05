//
//  URL.swift
//
//
//  Created by Yang Xu on 2023/9/5.
//

import Foundation
import SwiftData

public extension URL {
    // Computed property to create a PersistentIdentifier from a URL
    var persistentIdentifier: PersistentIdentifier? {
        guard scheme == "x-coredata",
              let host = host()
        else {
            return nil
        }
        let pathComponents = self.pathComponents
        guard pathComponents.count == 3 else {
            return nil
        }
        let entityName = pathComponents[1]
        let pk = pathComponents[2]
        let json = PersistentIdentifierJSON(
            implementation: .init(primaryKey: pk,
                                  uriRepresentation: self,
                                  isTemporary: false,
                                  storeIdentifier: host,
                                  entityName: entityName)
        )
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(json) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(PersistentIdentifier.self, from: data)
    }
}
