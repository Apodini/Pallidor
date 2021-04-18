//
//  ResponseModel.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

/// reponse of operation as stated in open api document
struct ResponseModel {
    internal init(type: String? = nil, formats: [OpenAPI.ContentType]? = nil, detail: String? = nil, code: OpenAPI.Response.StatusCode) {
        self.type = type
        self.formats = formats
        self.detail = detail
        self.code = code
    }
    
    /// type of response
    var type: String?
    /// list of formats of response (json/application only relevant)
    var formats: [OpenAPI.ContentType]?
    /// comment for this response
    var detail: String?
    /// the status code which this response contains
    var code: OpenAPI.Response.StatusCode
}

extension ResponseModel {
    /// Resolves the response for an operation as stated in open api document
    /// - Parameters:
    ///   - code: the status code which this response contains
    ///   - response: reponse of operation as stated in open api document
    /// - Returns: response model
    static func resolve(code: OpenAPI.Response.StatusCode, response: OpenAPI.Response) -> ResponseModel {
        guard  !response.content.values.isEmpty, let schema = response.content.values[0].schema else {
            return ResponseModel(detail: response.description, code: code)
        }
        let formats = response.content.keys
        var type: String
        
         do {
           type = try PrimitiveTypeResolver.resolveTypeFormat(schema: schema)
         } catch {
            type = "Error"
        }
        
        guard let actualType = TypeAliases.store[type.removePrefix] else {
            if !code.isSuccess {
                OpenAPIErrorModel.errorTypes.insert(type.isPrimitiveType ? type.removePrefix : type)
            }
            return ResponseModel(type: type, formats: formats, detail: response.description, code: code)
        }
        
        if !code.isSuccess {
            OpenAPIErrorModel.errorTypes.insert(actualType.isPrimitiveType ? actualType.removePrefix : actualType)
        }
        return ResponseModel(type: actualType, formats: formats, detail: response.description, code: code)
    }
}

extension ResponseModel: CustomStringConvertible {
    var description: String {
            type ?? "String"
    }
    /// error decoding for `OpenAPIError` errors
    var errorDecoderString: String {
            if let type = type {
                switch type {
                case "String":
                    return """
                    let content = String(data: data, encoding: .utf8)!
                    throw _OpenAPIError.\(OpenAPIErrorModel.getErrorType(type))(\(code.rawValue), content)
                    """
                case "Int":
                    return """
                    let content = Int(String(data: data, encoding: .utf8)!)
                    throw _OpenAPIError.\(OpenAPIErrorModel.getErrorType(type))(\(code.rawValue), content)
                    """
                case "Double":
                    return """
                    let content = Double(String(data: data, encoding: .utf8)!)
                    throw _OpenAPIError.\(OpenAPIErrorModel.getErrorType(type))(\(code.rawValue), content)
                    """
                default:
                    return """
                    let content = try decoder.decode(\(type.normalized).self, from: data)
                    throw _OpenAPIError.\(OpenAPIErrorModel.getErrorType(type))(\(code.rawValue), content)
                    """
                }
            }
            return "throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: \(code.rawValue))))"
    }
}
