//
//  PathHandler.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import PathKit

/// Creates the directory structure for Pallidor generated files
struct PathHandler {
    /// File manager instance
    let fileManager = FileManager()

    /// Target location of the generated code
    var targetDirectory: Path
    /// Name of the library
    var packageName: String
    
    /// only for debugging purposes
    private func clearPreviousLibrary() {
        #if DEBUG
        let packagePath = (targetDirectory + Path(packageName)).string
        if fileManager.fileExists(atPath: packagePath) {
            try? fileManager.removeItem(atPath: packagePath)
        }
        #endif
    }
    
    /// Creates the directory structure for the Swift Package to be generated
    /// - Throws: error if creating any directory fails
    func createDirectoryStructure() throws {
        clearPreviousLibrary()
        
        let outputPath = targetDirectory + Path("\(packageName)/Sources/\(packageName)/")
        let testPath = targetDirectory + Path("\(packageName)/Tests/\(packageName)Tests/")
        try fileManager.createDirectory(atPath: outputPath.absolute().string + "/Models/", withIntermediateDirectories: true, attributes: nil)
        try fileManager.createDirectory(atPath: outputPath.absolute().string + "/APIs/", withIntermediateDirectories: true, attributes: nil)
        try fileManager.createDirectory(
            atPath: outputPath.absolute().string +
            "/PersistentModels/",
            withIntermediateDirectories: true,
            attributes: nil)
        try fileManager.createDirectory(
            atPath: outputPath.absolute().string +
            "/PersistentAPIs/",
            withIntermediateDirectories: true,
            attributes: nil)
        try fileManager.createDirectory(
            atPath: testPath.absolute().string,
            withIntermediateDirectories: true,
            attributes: nil)
    }
}
