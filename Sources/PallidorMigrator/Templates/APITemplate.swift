//
//  APITemplate.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import PathKit

/// Template which represents the code structure for an endpoint
struct APITemplate: CodeTemplate {
    func render(_ modifiable: ModifiableFile) -> String {
        guard let facadeStruct = modifiable as? WrappedStruct else {
            fatalError("APITemplate requires struct.")
        }

        return
            """
            import Foundation
            import Combine
            \(facadeStruct.specialImports.joined(separator: "\n"))
            \(facadeStruct.annotation?.description ?? "")
            public struct \(facadeStruct.localName) {
                \(facadeStruct.variables.map { $0.declaration() }.joined(separator: "\n"))

                \(facadeStruct.methods.map { $0.apiMethodString() }.joined(separator: "\n\n"))

            }
            """
    }
}
