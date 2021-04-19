//
//  OperationModel.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit

/// Model for operations of endpoint
struct OperationModel {
    /// identifier from OpenAPI document
    var operationId: String
    /// comment
    var detail: String?
    /// method as stated in document
    var httpMethod: OpenAPI.HttpMethod
    /// path where method is located
    var path: OpenAPI.Path
    /// list of parameters for this method
    var parameters: [ParameterModel]?
    /// true if method requires authentication
    var requiresAuth: Bool = false
    
    /// filtered params for query params
    private var queryParams: [ParameterModel]? {
        parameters?.filter { param -> Bool in
            if case .query = param.location {
                return true
            }
            return false
        }
        .sorted(by: { $0.name < $1.name })
    }
    
    /// filtered params for path params
    private var pathParams: [ParameterModel]? {
        parameters?.filter { param -> Bool in
            if case .path = param.location {
                return true
            }
            return false
        }
        .sorted(by: { $0.name < $1.name })
    }
    
    /// filtered params for header params
    private var headerParams: [ParameterModel]? {
        parameters?.filter { param -> Bool in
            if case .header = param.location {
                return true
            }
            return false
        }
        .sorted(by: { $0.name < $1.name })
    }
    
    /// request body for this method if available
    var requestBody: RequestBodyModel?
    
    /// responses (errors and success) for this method
    var responses: [ResponseModel]
    
    /// success type for this method
    var successType: String {
        responses.first(where: { $0.code.isSuccess })?.description ?? "String"
    }
    
    /// list of possible failures for this method
    var failures: [ResponseModel] {
        responses.filter { !$0.code.isSuccess }
    }
    
    /// explicit failure type
    var failureType: String {
        responses.first(where: { !$0.code.isSuccess })?.description ?? "String"
    }
}

extension OperationModel {
    /// Resolves operations from open api document
    /// - Parameter endpoint: endpoint in which this method is located
    /// - Returns: operation model
    static func resolve(endpoint: ResolvedEndpoint) -> OperationModel {
        let requestBody = RequestBodyModel.resolve(request: endpoint.requestBody?.underlyingRequest)
        let responses = endpoint.responses.map { ResponseModel.resolve(code: $0, response: $1.underlyingResponse) }
        let parameters = endpoint.parameters.map { ParameterModel.resolve(param: $0) }
        guard let operationId = endpoint.operationId else {
            fatalError("Methods must specify an operation id!")
        }
         return OperationModel(
            operationId: operationId,
            detail: endpoint.endpointDescription,
            httpMethod: endpoint.method,
            path: endpoint.path,
            parameters: parameters,
            requiresAuth: !endpoint.security.isEmpty,
            requestBody: requestBody,
            responses: responses
         )
     }
}

extension OperationModel: CustomStringConvertible {
    var comment: String {
            """
            /**
            \(detail?.removeOAIIllegalCharacters() ?? "")
            \(requestBody != nil ?
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                "RequestBody:\n   - element \(requestBody!.detail ?? "")" : "")
            Responses:
            \(responses
                .sorted(by: { $0.code.rawValue < $1.code.rawValue })
                .map { $0.detail != nil ?
                    // Nil checked in previous statement
                    // swiftlint:disable:next force_unwrapping
                    "   - \($0.code.rawValue): \($0.detail!)" :
                    "   - \($0.code.rawValue)"
                }
                .joined(separator: "\n"))
            */
            """
    }
    
    /// mapping for failures of method
    var failureTryMap: String {
            """
            .tryMap { data, response in
                    guard let r = response as? HTTPURLResponse, 200..<299 ~= r.statusCode else {
                    let httpResponse = response as! HTTPURLResponse
            
                    \(failures
                        .sorted(by: { $0.code.rawValue < $1.code.rawValue })
                        .map { failure -> String in
                            failure.code.rawValue != "default" ?
                                """
                                if httpResponse.statusCode == \(failure.code.rawValue) {
                                    \(failure.errorDecoderString)
                                }
                                """
                                :
                                ""
                        }
                    .joined(separator: "\n"))
            
                        throw _OpenAPIError.urlError(URLError(URLError.Code(rawValue: httpResponse.statusCode)))
                    }
                    \(successDecoding)
            }
            """
    }
    
    /// success decoding for method
    var successDecoding: String {
            successType.isPrimitiveAndNoCollection
                ? successType == "String" ? "return String(data: data, encoding: .utf8)!" : "return \(successType)(String(data: data, encoding: .utf8)!)!"
            : "return data"
    }
    
    /// changes content type if request body is in binary format
    var specialContentType: String? {
            if let requestBody = requestBody {
                return requestBody.formats.contains(where: { $0.rawValue == "application/octet-stream" }) ?
                    " = \"application/octet-stream\""
                    : nil
            }
            return nil
    }
    
    /// description for this methods `NetworkManager` call
    var operationDescription: String {
        let headers = headerParams != nil &&
            // Nil checked in previous statement
            // swiftlint:disable:next force_unwrapping
            !headerParams!.isEmpty ? ", headers: customHeaders" : ""
        switch httpMethod {
        case .get:
            return "return NetworkManager.getElement(on: URL(string: path)!, authorization: authorization, contentType: contentType\(headers))"
        case .post:
            return requestBody != nil ? "return NetworkManager.postElement(element, authorization: authorization, on: URL(string: path)!, contentType: contentType\(headers))" : "return NetworkManager.postElement(authorization: authorization, on: URL(string: path)!, contentType: contentType\(headers))"
        case .patch:
            return requestBody != nil ? "return NetworkManager.patchElement(element, authorization: authorization, on: URL(string: path)!, contentType: contentType\(headers))" : "return NetworkManager.patchElement(authorization: authorization, on: URL(string: path)!, contentType: contentType\(headers))"
        case .put:
            return requestBody != nil ? "return NetworkManager.putElement(element, authorization: authorization, on: URL(string: path)!, contentType: contentType\(headers))" : "return NetworkManager.putElement(authorization: authorization, on: URL(string: path)!, contentType: contentType\(headers))"
        case .delete:
            return "return NetworkManager.delete(at: URL(string: path)!, authorization: authorization, contentType: contentType\(headers))"
        case .head:
            return "return NetworkManager.head(at: URL(string: path)!, authorization: authorization, contentType: contentType\(headers))"
        case .options:
            return "return NetworkManager.options(at: URL(string: path)!, authorization: authorization, contentType: contentType\(headers))"
        case .trace:
            return "return NetworkManager.trace(at: URL(string: path)!, authorization: authorization, contentType: contentType\(headers))"
        }
    }
    
    var description: String {
            let parametersString: [String?] =
                [
                    parameters != nil ?
                        // Nil checked in previous statement
                        // swiftlint:disable:next force_unwrapping
                        parameters!
                        .sorted(by: { $0.name <= $1.name })
                        .map { $0.description }
                        .joined(separator: ", ") : nil,
                    requestBody != nil ?
                        // Nil checked in previous statement
                        // swiftlint:disable:next force_unwrapping
                        requestBody!.description : nil,
                    """
authorization: HTTPAuthorization\(
    requiresAuth ? "" : "?") = NetworkManager.authorization\(
        requiresAuth ? "!" : ""), contentType: String?\(
            specialContentType != nil ?
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                specialContentType! : " = NetworkManager.defaultContentType")
"""
                ]
            let isGeneric = NotOfResolver.isGeneric(type: successType)
            let parameterGuards = parameters != nil &&
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                !parameters!.isEmpty ?
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                parameters!.map { $0.limitGuard }
                .skipEmptyJoined(separator: "\n") : ""
            return """
            \(comment)
            static func \(operationId)\(isGeneric ? "<T : Codable>" : "")(\(parametersString.skipEmptyJoined(separator: ", "))) -> AnyPublisher<\(isGeneric ? "\(successType)<T>" : successType), Error> {
            \(parameters != nil &&
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                !parameters!.isEmpty ? "var" : "let") path = NetworkManager.basePath! + "\(path.rawValue)"
                \(pathParams != nil ?
                    // Nil checked in previous statement
                    // swiftlint:disable:next force_unwrapping
                    pathParams!.map { $0.opDescription }.joined(separator: "\n") : "")
            \(queryParams != nil &&
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                !queryParams!.isEmpty ? "path += \"?\(queryParams!.first!.required ? "\(queryParams!.map { $0.opDescription }.joined().dropFirst())\"" : "\(queryParams!.map { $0.opDescription }.joined())\"")" : "")
            \(headerParams != nil &&
                // Nil checked in previous statement
                // swiftlint:disable:next force_unwrapping
                !headerParams!.isEmpty ? "var customHeaders = [String : String]()\n\(headerParams!.map { $0.opDescription }.joined(separator: "\n"))" : "")
                \(parameterGuards.isEmpty ? "" : "\(parameterGuards)\n")\(operationDescription)
            \(failureTryMap)\(successType.isPrimitiveAndNoCollection ? "" : "\n.decode(type: \(successType).self, decoder: decoder)")
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            }

            """
    }
}
