//
//  CodeTemplate.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import PathKit

/// Protocol all templates need to conform to
protocol CodeTemplate {
    /// Required initializer to allow instance initialization from type
    init()
    
    /// renders the modifiable to its corresponding string representation in source code
    /// - Parameter modifiable: modifiable
    func render(_ modifiable: ModifiableFile) -> String
}

extension CodeTemplate {
    /// writes the rendered source code string representation to disk
    /// - Parameters
    ///     - modifiable: modifiable file
    ///     - path: path where the modifiable should be written to
    func write(_ modifiable: ModifiableFile, to path: Path) throws -> URL? {
        try path.write(content: render(modifiable))
    }
}
