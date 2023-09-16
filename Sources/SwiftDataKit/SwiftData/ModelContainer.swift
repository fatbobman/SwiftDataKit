//
//  File.swift
//
//
//  Created by Yang Xu on 2023/9/16.
//

import CoreData
import Foundation
import SwiftData

extension ModelContainer {
    // Computed property to access the NSManagedObjectModel
    @MainActor
    var objectModel: NSManagedObjectModel? {
        mainContext.objectModel
    }
}
