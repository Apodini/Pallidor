//
//  APIConverter.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit
import PathKit

/// Converter for API endpoints from specfication
struct APIConverter: Converting {
    init(_ resolvedDocument: ResolvedDocument) {
        self.resolvedDocument = resolvedDocument
    }
    
    var resolvedDocument: ResolvedDocument
    
    var endpoints: [EndpointModel] = [EndpointModel]()
    
    mutating func parse() {
        for (path, route) in resolvedDocument.routesByPath {
            let endpoint = EndpointModel.resolve(path: path, route: route)
            guard let same = endpoints.first(where: { $0 == endpoint }) else {
                endpoints.append(endpoint)
                continue
            }
            same.operations.append(contentsOf: endpoint.operations)
        }
    }
    
    func getEndpoint(_ name: String) -> EndpointModel? {
        endpoints.first(where: { $0.name == name })
    }
    
    func getOperation(_ name: String, in endpoint: String) -> OperationModel? {
        getEndpoint(endpoint)?.operations.first(where: { $0.operationId == name })
    }
    
    mutating func writeToFile(path: Path) throws -> [URL] {
        var filePaths = [URL]()
        
        for endpoint in endpoints {
            let fileName = path + Path("_\(endpoint.name)API.swift")
            try endpoint.description.write(to: fileName.url, atomically: true, encoding: .utf8)
            filePaths.append(fileName.url)
        }
        return filePaths
    }
}
