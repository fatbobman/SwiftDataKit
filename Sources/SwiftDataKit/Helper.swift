//
//  File.swift
//  
//
//  Created by Yang Xu on 2023/8/23.
//

import Foundation
import SwiftData
import CoreData

func getMirrorChildValue(of object: Any, childName: String) -> Any? {
    guard let child = Mirror(reflecting: object).children.first(where: { $0.label == childName }) else {
        return nil
    }

    return child.value
}
