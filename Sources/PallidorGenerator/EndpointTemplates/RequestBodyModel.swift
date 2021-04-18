//
//  RequestBodyModel.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

/// request body of an operation from open api document
struct RequestBodyModel {
    /// list of content types this request body conforms to.
    /// only json/application is relevant
    var formats: [OpenAPI.ContentType]
    /// type of request body
    var type: String
    /// true if request body is required
    var required: Bool
    /// comment for this request body
    var detail: String?
}

extension RequestBodyModel {
    /// Resolves a request body from OpenAPI document
    /// - Parameter request: request as stated in open api document
    /// - Returns: request body model
    static func resolve(request: OpenAPI.Request?) -> RequestBodyModel? {
        guard let request = request else {
            return nil
        }
        let formats = request.content.keys
        guard let type = try? PrimitiveTypeResolver.resolveTypeFormat(schema: request.content.values[0].schema) else {
            fatalError("Type format could not be resolved for request body.")
        }
        return RequestBodyModel(formats: formats, type: type, required: request.required, detail: request.description)
    }
}

extension RequestBodyModel: CustomStringConvertible {
    var description: String {
        "element: \(type)\(required ? "" : "?")"
    }
}
