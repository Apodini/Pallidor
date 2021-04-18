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
    var location: Location
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
                return "path = path.replacingOccurrences(of: \"{\(name)}\", with: String(\(name)))"
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
                if (self.type == "String" || self.type.isPrimitiveArray) && min == 0 {
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
    
    /// Possible location of parameters
    enum Location: Equatable {
        case path(String)
        case query(String)
        case header(String)  /** not "Accept", "Content-Type" or "Authorization" */
        case cookie(String)
    }
}

extension ParameterModel {
    /// Resolves parameter from OpenAPI document operation
    /// - Parameter param: Parameter from OpenAPI document
    /// - Returns: ParameterModel object
    static func resolve(param: DereferencedParameter) -> ParameterModel {
        var location = ParameterModel.Location.path(param.name)
        
        switch param.location {
        case .cookie:
            location = .cookie(param.name)
        case .header:
            location = .header(param.name)
        case .query:
            location = .query(param.name)
        case .path:
            break
        }
        
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
            location: location,
            required: param.required,
            min: minMax.0,
            max: minMax.1
        )
    }
}
