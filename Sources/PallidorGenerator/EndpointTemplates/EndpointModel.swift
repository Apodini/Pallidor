//
//  EndpointModel.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

class EndpointModel {
    init(name: String, operations: [OperationModel], detail: String? = nil) {
        self.name = name
        self.operations = operations
        self.detail = detail
    }
    
    /// name of endpoint
    var name: String
    /// list of operations from this endpoint
    var operations: [OperationModel]
    /// comment for this endpoint
    var detail: String?
}

extension EndpointModel {
    /// Resolves an endpoint
    /// - Parameters:
    ///   - path: path in OpenAPI document
    ///   - route: Resolved route from OpenAPI document
    /// - Returns: resolved EndpointModel
    static func resolve(path: OpenAPI.Path, route: ResolvedRoute) -> EndpointModel {
        let endpointName = route.endpoints.apodiniEndpointName?.upperFirst() ?? path.components[0].upperFirst()
        let endpoint = EndpointModel(name: endpointName, operations: [], detail: route.summary)
        endpoint.operations = route.endpoints.map { OperationModel.resolve(endpoint: $0) }
        return endpoint
    }
}

fileprivate extension Array where Element == ResolvedEndpoint {
    var apodiniEndpointName: String? {
        first?.endpointVendorExtensions["x-pallidorEndpointName"]?.value as? String
    }
}

extension ResolvedEndpoint {
    var apodiniOperationName: String? {
        endpointVendorExtensions["x-pallidorOperationName"]?.value as? String
    }
}

extension EndpointModel: CustomStringConvertible {
    var description: String {
            """
            import Foundation
            import Combine
            
            \(detail != nil ?
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                "/**\(detail!.removeOAIIllegalCharacters())*/" : "")
            struct _\(name.upperFirst())API {
                static let decoder : JSONDecoder = NetworkManager.decoder
            
            \(operations.sorted(by: { $0.operationId < $1.operationId }).map { $0.description }.joined(separator: "\n"))
            
            }

            """
    }
}

extension EndpointModel: Equatable {
    static func == (lhs: EndpointModel, rhs: EndpointModel) -> Bool {
        lhs.name == rhs.name
    }
}
