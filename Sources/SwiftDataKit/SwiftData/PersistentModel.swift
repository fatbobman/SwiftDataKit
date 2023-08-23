//
//  PersistentModel.swift
//
//
//  Created by Yang Xu on 2023/8/23.
//

import CoreData
import Foundation
import SwiftData

public extension PersistentModel {
    var managedObject: NSManagedObject {
        guard let object = getMirrorChildValue(of: persistentBackingData, childName: "_managedObject") as? NSManagedObject else {
            fatalError("\(#file) \(#line) Can't get ManagedObject from PersistentModel:\(self)")
        }
        return object
    }
}
