// Disabled pattern_matching_keywords because its enforced by OpenAPIKIT
// swiftlint:disable pattern_matching_keywords

//
//  AllOfResolver.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

/// Resolves all $allOf types in document
enum AllOfResolver {
    /// Resolve $allOf types in document
    /// - Parameters:
    ///   - name: name of object
    ///   - schemas: schemas to check
    /// - Returns: Object model
    static func resolve(objectName name: String, schemas: [JSONSchema]) -> ObjectModel {
        var primary = ObjectModel(name: name, attributes: [], detail: "")
        var inherited = [AttributeModel]()
        for schema in schemas {
            switch schema {
            case .object(let core, let object):
                primary = ObjectResolver.resolve(name: name, context: core, schema: object)
            case .reference(let refContext):
                guard let attributes = try? ReferenceResolver.resolveAttributes(reference: refContext) else {
                    fatalError("No attributes could be resolved - allOf must contain attributes.")
                }
                inherited.append(contentsOf: attributes)
            default:
                break
            }
        }
        primary.attributes.append(contentsOf: inherited)
        return primary
    }
}
