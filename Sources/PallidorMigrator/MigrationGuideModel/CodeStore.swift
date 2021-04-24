//
//  CodeStore.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SourceryFramework
import PathKit

/// Scope of layers
enum Scope: CaseIterable {
    case current
    case previousFacade
    
    private var folderPrefix: String {
        self == .current ? "" : "Persistent"
    }
    
    var modelsPath: Path {
        return Path("\(folderPrefix)Models")
    }
    
    var apisPath: Path {
        return Path("\(folderPrefix)APIs")
    }
    
    var errorEnumFileName: String {
        "\(self == .current ? "_" : "")APIErrors.swift"
    }
}

/// Location of storing the parsed source code (API & previous Facade)
public class CodeStore {
    
    /// Singleton of code store instance, by default empty
    public static var instance = CodeStore()
    
    /// parsed source code located in facade folders
    var previousFacade: [ModifiableFile]
    /// parsed source code located in API folders
    var currentAPI: [ModifiableFile]

    private init() {
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
        let errorEnumFileName = scope.errorEnumFileName
        
        let modelFileNames = FileManager
            .swiftFilesInDirectory(atPath: modelsDirectory.string + "/")
            .sorted(by: { $0 == "_APIAliases.swift" || $0 == "APIAliases.swift" || $0 < $1 })
        
        let apiFileNames = FileManager.swiftFilesInDirectory(atPath: apisDirectory.string + "/")
        
        importModifiableFiles(with: modelFileNames, from: modelsDirectory, for: scope)
        
        importModifiableFiles(with: apiFileNames, from: apisDirectory, for: scope)
        
        importModifiableFiles(with: [errorEnumFileName], from: targetDirectory, for: scope)
    }
    
    /// Reads and parses the source code inside of target directories and stores it in the CodeStore
    /// - Parameters:
    ///   - fileNames: swift file names
    ///   - directory: path of directory
    ///   - scope: scope where the code should be read from
    private func importModifiableFiles(with fileNames: [String], from directory: Path, for scope: Scope) {
        do {
            for file in fileNames {
                let absolutePath = directory + Path(file)
                let content = try absolutePath.read(.utf8)
                let fileparser = try FileParser(contents: content, path: absolutePath)
                let code = try fileparser.parse()
                guard let types = WrappedTypes(types: code.types).modifiableFile else {
                    fatalError("Modifiable file could not be retrieved.")
                }
                scope == .current ? currentAPI.append(types) : previousFacade.append(types)
            }
        } catch {
            fatalError("Endpoints could not be loaded.")
        }
    }
}
