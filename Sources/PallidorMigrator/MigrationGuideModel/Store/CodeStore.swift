//
//  CodeStore.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import PathKit

/// Location of storing the parsed source code (API & previous Facade)
class CodeStore: Store {
    /// parsed source code located in facade folders
    var previousFacade: [ModifiableFile]
    /// parsed source code located in API folders
    var currentAPI: [ModifiableFile]
    
    /// Initializes the code store with empty layers
    init() {
        previousFacade = []
        currentAPI = []
    }
    
    /// Collects source code form Models and APIs folders, and the respective error enums
    /// - Parameter targetDirectory: path to source code files
    func collect(at targetDirectory: Path) {
        Scope.allCases.forEach { collectCode(for: $0, in: targetDirectory) }
        
        assert(!currentAPI.isEmpty, "Current API must be present")
    }
    
    /// Reads and parses the source code inside of target directories
    /// - Parameters:
    ///   - scope: scope where the code should be read from
    ///   - targetDirectory: path of target directory
    private func collectCode(for scope: Scope, in targetDirectory: Path) {
        let modelsDirectory = targetDirectory + scope.modelsPath
        let apisDirectory = targetDirectory + scope.apisPath
        
        let modelFileNames = FileManager
            .swiftFilesInDirectory(atPath: modelsDirectory.string + "/")
            .sorted(by: { $0 == "_APIAliases.swift" || $0 == "APIAliases.swift" || $0 < $1 })
        
        let apiFileNames = FileManager.swiftFilesInDirectory(atPath: apisDirectory.string + "/")
        
        importModifiableFiles(with: modelFileNames, from: modelsDirectory, for: scope)
        
        importModifiableFiles(with: apiFileNames, from: apisDirectory, for: scope)
        
        importModifiableFiles(with: [scope.errorEnumFileName], from: targetDirectory, for: scope)
    }
    
    /// Reads and parses the source code inside of target directories and stores it in the CodeStore
    /// - Parameters:
    ///   - fileNames: swift file names
    ///   - directory: path of directory
    ///   - scope: scope where the code should be read from
    private func importModifiableFiles(with fileNames: [String], from directory: Path, for scope: Scope) {
        for path in fileNames.map({ directory + Path($0) }) {
            if let content = try? path.read(.utf8) { // `APIErrors` not available in first generation, hence ignoring read throw
                insert(modifiable: modifiableFile(from: content, path: path), in: scope)
            }
        }
    }
}
