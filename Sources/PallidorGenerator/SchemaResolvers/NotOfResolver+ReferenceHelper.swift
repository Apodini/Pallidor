//
//  NotOfResolver+ReferenceHelper.swift
//  
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

extension NotOfResolver {
    /// types which are references in NotModels
    static var notOfReferences = [String]()
    /// types which are referenced by NotModel references
    static var notOfReferred = [String]()
    
    /// Returns true if the given type is generic (only possible when somehow referenced to $not model)
    /// - Parameter type: type to check
    /// - Returns: true if generic
    static func isGeneric(type: String) -> Bool {
        notOfReferred.contains(type) || notOfReferences.contains(type)
    }
    
    
    /// Resolves all objects which reference a $not model either directly or indirectly
    /// - Parameter objects: list of object models to check
    static func resolveReferenced(objects: [ObjectModel?]) {
        for object in objects {
            guard let object = object else {
                continue
            }
            
            for attribute in object.attributes {
                let isRef = notOfReferences.contains(attribute.type) || notOfReferred.contains(attribute.type)
                let isKnown = object.isGeneric
                
                if isKnown {
                    continue
                }
                
                if isRef {
                    notOfReferred.append(object.name)
                    object.isGeneric = true
                    resolveReferenced(objects: objects)
                }
            }
        }
    }
}
