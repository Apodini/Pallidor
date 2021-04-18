//
//  TypeAliases.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

enum TypeAliases {
    /** Parses all type aliases in open api document
     *  A type alias in the open api specification is defined for this library
     *  as a top level schema component which does not contain any properties
     *  but simply refers to another type (either primitive or complex).
     * - Parameter resolvedDoc: parsed document from OpenAPIKit
    */
    static func parse(resolvedDoc: ResolvedDocument) {
        for (name, schema) in resolvedDoc.components.schemas {
            switch schema {
            case .integer(let generalContext, _):
                if generalContext.allowedValues == nil {
                    let attributeType = generalContext.format.rawValue.isEmpty ? "Int" : generalContext.format.rawValue.capitalized
                    TypeAliases.store[name.rawValue] = attributeType
                }
            case .number(let generalContext, _):
                if generalContext.allowedValues == nil {
                    let attributeType = generalContext.format.rawValue.isEmpty ? "Double" : generalContext.format.rawValue.capitalized
                    TypeAliases.store[name.rawValue] = attributeType
                }
            case .string(let generalContext, _):
                if generalContext.allowedValues == nil {
                    TypeAliases.store[name.rawValue] = "String"
                }
            case .array(_, let context):
                guard let items = context.items else {
                    fatalError("Array must specify at least one item.")
                }
                let type = ArrayResolver.resolveArrayItemType(schema: items)
                TypeAliases.store[name.rawValue] = "[\(type)]"
            default:
                break
            }
        }
    }
    
    /// temp. storage where all type aliases are mapped to their actual types
    static var store: [String: String] = [String: String]()
}
