// Disabled pattern_matching_keywords because its enforced by OpenAPIKIT
// swiftlint:disable pattern_matching_keywords

//
//  PropertyResolver.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

/// Resolves properties stated in open api document
enum PropertyResolver {
    /// Resolves properties from object model
    /// - Parameters:
    ///   - name: name of attribute
    ///   - schema: schema to check
    /// - Throws: error if schema cannot be resolved
    /// - Returns: resolved AttributeModel
    // Complexity required to resolve type.
    // Implementation by OpenAPIKit
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    static func resolve(name: String, schema: JSONSchema) throws -> AttributeModel {
        switch schema {
        case .boolean(let generalContext):
            return AttributeModel(
                name: name,
                type: "Bool",
                isRequired: generalContext.required,
                detail: generalContext.description
            )
        case .integer(let generalContext, _):
            let attributeType = PrimitiveTypeResolver.resolveTypeFormat(context: generalContext)
            
            let attributeModel = AttributeModel(
                name: name,
                type: attributeType,
                isRequired: generalContext.required,
                detail: generalContext.description
            )
            
            attributeModel.enumValues = checkEnumValues(enumValues: generalContext.allowedValues)
            
            return attributeModel
            
        case .number(let generalContext, _):
            let attributeType = PrimitiveTypeResolver.resolveTypeFormat(context: generalContext)
            
            let attributeModel = AttributeModel(
                name: name,
                type: attributeType,
                isRequired: generalContext.required,
                detail: generalContext.description
            )
            
            attributeModel.enumValues = checkEnumValues(enumValues: generalContext.allowedValues)
            
            return attributeModel
            
        case .string(let generalContext, _):
            let attributeType = PrimitiveTypeResolver.resolveTypeFormat(context: generalContext)
            
            let attributeModel = AttributeModel(
                name: name,
                type: attributeType,
                isRequired: generalContext.required,
                detail: generalContext.description
            )
            
            attributeModel.enumValues = checkEnumValues(enumValues: generalContext.allowedValues)
            
            return attributeModel
        case .reference:
            return AttributeModel(
                name: name,
                type: try ReferenceResolver.resolveName(schema: schema),
                isRequired: false,
                detail: nil
            )
        case .array(let general, let arrayContext):
            guard let items = arrayContext.items else {
                fatalError("Array must contain at least one item.")
            }
            let attr = AttributeModel(
                name: name,
                type: ArrayResolver.resolveArrayItemType(schema: items),
                isRequired: general.required,
                detail: general.description
            )
            attr.isArray = true
            return attr
        case .all(of: _):
            throw ResolvementError.notSupported(msg: "All Of not implemented: " + name)
        case .object(let general, let objectContext):
            guard (objectContext.additionalProperties?.b) != nil  else {
                throw ResolvementError.nestedObjectError(msg: "Nested attribute found in: " + name)
            }
            return AttributeModel(
                name: name,
                type: "[String:String]",
                isRequired: general.required,
                detail: general.description
            )
        case .fragment:
            throw ResolvementError.notSupported(msg: "Fragment not implemented: " + name)
        case .any(of: _, core: _):
            throw ResolvementError.notSupported(msg: "Any Of not implemented: " + name)
        case .not(schema, core: _):
            throw ResolvementError.notSupported(msg: "Not Of not implemented: " + name)
        default:
            throw ResolvementError.unknownType(msg: "No type could be found for: " + name)
        }
    }
    
    
    /// Checks and converts enum values
    /// - Parameter enumValues: List of AnyCodable enum values
    /// - Returns: List of converted enum values
    static func checkEnumValues(enumValues: [AnyCodable]?) -> [String]? {
        if let enumValues = enumValues {
            return enumValues.map { value -> String in
                if let value = value.value as? Int {
                    return String(value)
                } else {
                    // Must be String if it's not an integer.
                    // swiftlint:disable:next force_cast
                    return value.value as! String
                }
            }
        }
        return nil
    }
}
