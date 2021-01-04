//
//  Generator.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import PallidorGenerator
import PathKit

/// Generator for parsing an OpenAPI specification and generating a library from it
struct Generator {
    /// path to the specification JSON
    var specificationPath: URL
    /// path to the directory where output files shall be located
    var targetDirectory: Path
    /// name of the library to be generated
    var packageName: String
    
    
    /// Parses an OpenAPI specification and generates a library
    /// - Throws: error if generating the library fails
    /// - Returns: list of file URLs of generated library
    func generate() throws -> [URL] {
        let generator = try PallidorGenerator(specification: specificationPath)
        let filePaths = try generator.generate(target: targetDirectory, package: packageName)
        
        return filePaths
    }
}
