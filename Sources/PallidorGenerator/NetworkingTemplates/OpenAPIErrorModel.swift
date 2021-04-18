//
//  OpenAPIErrorModel.swift
//
//  Created by Andre Weinkoetz on 24.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// Meta model for collecting all error types to make them available for library
struct OpenAPIErrorModel: CustomStringConvertible {
    /// set of error types
    static var errorTypes = Set<String>()
    
    /// Maps a type to its error representation
    /// - Parameter type: type which should be wrapped as error type
    /// - Returns: error type
    static func getErrorType(_ type: String) -> String {
        let errorType = type.replaceBrackets
        return "response\(errorType.normalized)Error"
    }
        
    var description: String {
            """
            import Foundation
            
            enum _OpenAPIError : Error {
            
            \(OpenAPIErrorModel.errorTypes
                .map { "case response\($0.replaceBrackets.normalized.removePrefix)Error(Int, \($0.replaceBrackets))" }
                .joined(separator: "\n"))
                case urlError(URLError)
            }
            
            // sourcery:begin: ignore
            enum APIEncodingError: Error {
                case canNotEncodeOfType(Codable.Type)
            }
            // sourcery:end

            """
    }
}
