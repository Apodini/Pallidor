//
//  ArrayResolver.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

/// Resolves array types defined in open api document
enum ArrayResolver {
    /// Resolve the type as String of the items within an array from a JSONSchema
     /// - Parameter schema: JSONSchema which needs to be checked
     /// - Returns: type as String
     static func resolveArrayItemType(schema: JSONSchema) -> String {
         switch schema {
         case .boolean:
             return "Bool"
         case .integer(let context, _):
             return PrimitiveTypeResolver.resolveTypeFormat(context: context)
         case .number(let context, _):
            return PrimitiveTypeResolver.resolveTypeFormat(context: context)
         case .string(let context, _):
             return PrimitiveTypeResolver.resolveTypeFormat(context: context)
         case .array(_, let arrayContext):
            guard let items = arrayContext.items else {
                fatalError("Array must contain at least one item.")
            }
            return "[\(resolveArrayItemType(schema: items))]"
         case .reference:
            guard let name = try? ReferenceResolver.resolveName(schema: schema) else {
                fatalError("Root level array must have an identifier.")
            }
            return name
         default:
             return ""
         }
     }
}
