//
//  OneOfResolver.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

/// Resolves all $oneOf types in document
enum OneOfResolver {
    /// Resolve $onelOf types in document
    /// - Parameters:
    ///   - name: name of object
    ///   - schemas: schemas to check
    /// - Returns: OfModel model
    static func resolve(objectName name: String, schemas: [JSONSchema]) -> OfModel {
        let model = OfModel(name: name, detail: "", typeOf: .oneOf, inheritedObjects: [])
        
        let inheritedObjects = schemas.map { schema -> String in
            guard let name = try? ReferenceResolver.resolveName(schema: schema) else {
                fatalError("Reference could not be resolved")
            }
            return name
        }
        
        let attributes = inheritedObjects.map {
            AttributeModel(name: "none", type: $0, isRequired: true, detail: "")
        }
        
        model.inheritedObjects = inheritedObjects
        model.attributes = attributes
        
        return model
    }
}
