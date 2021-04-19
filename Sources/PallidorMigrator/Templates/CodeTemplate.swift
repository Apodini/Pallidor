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
    /// renders the modifiable to its corresponding string representation in source code
    /// - Parameter modifiable: modifiable
    func render(_ modifiable: Modifiable) -> String
}

extension CodeTemplate {
 
    /// writes the rendered source code string representation to disk
    /// - Parameter modifiable: modifiable
    func write(_ modifiable: Modifiable, to path: Path) throws -> URL? {
        let content = render(modifiable)

        guard !content.isEmpty else {
            return nil
        }

        let outputPath = URL(fileURLWithPath: path.string)
        try content.write(to: outputPath, atomically: true, encoding: .utf8)
        return outputPath
    }
}
