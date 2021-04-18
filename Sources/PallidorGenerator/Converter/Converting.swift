//
//  Converting.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import OpenAPIKit
import PathKit

/// protocol all Converters must conform to
protocol Converting {
    /// resolved document from open api specification (parsed by OpenAPIKit)
    var resolvedDocument: ResolvedDocument { get set }
    
    /// Writes the converted items to files
    /// - Parameter path: target directory path
    mutating func writeToFile(path: Path) throws -> [URL]
    
    /// Parses the items from OpenAPIKit
    mutating func parse()
}
