//
//  File.swift
//
//
//  Created by Yang Xu on 2023/8/23.
//

import CoreData
import Foundation
import SwiftData

/// Returns the value of a child property of an object using reflection.
///
/// - Parameters:
///   - object: The object to inspect.
///   - childName: The name of the child property to retrieve.
/// - Returns: The value of the child property, or nil if it does not exist.
func getMirrorChildValue(of object: Any, childName: String) -> Any? {
    guard let child = Mirror(reflecting: object).children.first(where: { $0.label == childName }) else {
        return nil
    }

    return child.value
}
