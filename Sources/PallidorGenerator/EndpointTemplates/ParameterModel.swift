//
//  ParameterModel.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

/// model for parameters
struct ParameterModel: CustomStringConvertible {
    var description: String {
            """
\(name): \(type)\(required ? "" : "?")\(defaultValue != nil ?
                                            // Nil checked in previous statement
                                            // swiftlint:disable:next force_unwrapping
                                            (type == "String" ? " = \"\(defaultValue!)\"" : " = \(defaultValue!)")  : "")
"""
    }
    
    /// name of this parameter
    var name: String
    /// type of this parameter
    var type: String
    /// comment for this parameter
    var detail: String?
    /// default value for this parameter
    var defaultValue: String?
    /// location of parameter (header, query, cookie, path)
    var location: ParameterLocation
    /// true if param is required in specification
    var required: Bool = false
    
    /// minMax values as specified in OpenAPI document
    /// e.g. minMaxLength for Strings or minMax for Integers
    var min: Int?
    var max: Int?
    
    /// description inside method body
    var opDescription: String {
            switch location {
            case .cookie:
                return ""
            case .path(let name):
                return "path = path.replacingOccurrences(of: \"{\(name)}\", with: \(name).description)"
            case .query(let name):
                return  required ?
                    "&\(name)=\\(\(queryInitializer)\(type.contains("[") ? "\(!required ? "?" : "" ).joined(separator: \"&\")" : "")\(!required ? " ?? \"\"" : ""))"
                    : "\\(\(name) != nil ? \"&\(name)=\\(\(queryInitializer)\(type.contains("[") ? "\(!required ? "?" : "" ).joined(separator: \"&\")" : "")\(!required ? " ?? \"\"" : ""))\" : \"\")"
            case .header(let headerField):
                return "customHeaders[\"\(headerField)\"] = \(required ? "\(name).description" : "\(name)?.description ?? \"\"")"
            }
    }
    
    enum LimitError: Error {
        case minMaxViolation(String)
    }
    
    /// provides the `guard` code block for ensuring that a parameter is in the required range.
    var limitGuard: String? {
            let variable = "\(self.name)\(self.required ? "" : "!")\(self.type == "String" ? ".count" : "")"
            
            if let min = self.min, let max = self.max {
                return """
                    assert(\(variable) >= \(min) && \(variable) <= \(max), "\(self.name) exceeds its limits")
                """
            }
            
            if let min = self.min {
                if (["UUID", "String"].contains(type) || self.type.isPrimitiveArrayType) && min == 0 {
                    return nil
                }
                return """
                    assert(\(variable) >= \(min), "\(self.name) falls below its lower limit.")
                """
            }
            
            if let max = self.max {
                return """
                    assert(\(variable) <= \(max), "\(self.name) exceeds its upper limit" )
                """
            }
                        
            return nil
    }
    
    private var queryInitializer: String {
        name == "String" || type.contains("[") ? name : "\(name)\(required ? "" : "?").description"
    }
}

extension ParameterModel {
    
    var isPath: Bool {
        if case .path = location {
            return true
        }
        return false
    }
    
    var isQuery: Bool {
        if case .query = location {
            return true
        }
        return false
    }
    
    var isHeader: Bool {
        if case .header = location {
            return true
        }
        return false
    }
    
    var isCookie: Bool {
        if case .cookie = location {
            return true
        }
        return false
    }
}

extension Array where Element == ParameterModel {
    
    func filtered(_ isIncluded: (Element) -> Bool) -> Self {
        filter(isIncluded).sorted(by: { $0.name < $1.name })
    }
    
    var assertDescription: String {
        isEmpty ? "" : "NetworkManager.assertPathParameters(\(map { $0.name }.joined(separator: ", ")))\n"
    }
}

extension ParameterModel {
    /// Resolves parameter from OpenAPI document operation
    /// - Parameter param: Parameter from OpenAPI document
    /// - Returns: ParameterModel object
    static func resolve(param: DereferencedParameter) -> ParameterModel {
        let defaultValue = PrimitiveTypeResolver.resolveDefaultValue(schema: param.schemaOrContent.schemaValue)
        let minMax = PrimitiveTypeResolver.resolveMinMax(schema: param.schemaOrContent.schemaValue)
                
        guard let schemaContext = param.schemaOrContent.a,
              let type = try? PrimitiveTypeResolver.resolveTypeFormat(schema: schemaContext.schema)
        else {
            fatalError("Primitive type could not be resolved.")
        }
        
        return ParameterModel(
            name: param.name,
            type: type,
            detail: param.description,
            defaultValue: defaultValue,
            location: .init(parameter: param),
            required: param.required,
            min: minMax.0,
            max: minMax.1
        )
    }
}
