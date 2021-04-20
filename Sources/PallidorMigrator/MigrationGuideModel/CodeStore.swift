//
//  CodeStore.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import SourceryFramework
import PathKit

/// Location of storing the parsed source code (API & previous Facade)
public class CodeStore {
    /// Scope of layers
    enum Scope {
        case current
        case previous
    }
    
    private static var instance: CodeStore?
    
    private static var _instance: CodeStore { // swiftlint:disable:this identifier_name
        guard let instance = instance else {
            fatalError("Code store was not properly initialized.")
        }
        return instance
    }

    /// parsed source code located in facade folders
    var previousFacade: [ModifiableFile]?
    /// parsed source code located in API folders
    var currentAPI: [ModifiableFile] = []

    /// true after initial setup
    var hasFacade: Bool {
        previousFacade != nil && previousFacade?.isEmpty == true
    }

    private init(previousFacade: [ModifiableFile], currentAPI: [ModifiableFile]) {
        self.previousFacade = previousFacade
        self.currentAPI = currentAPI
    }

    private init(targetDirectory: Path) {
        guard let currentAPI = getCode(
                modelPath: targetDirectory + Path("Models"),
                apiPath: targetDirectory + Path("APIs")
        ) else {
            fatalError("Current API must be present.")
        }
        self.currentAPI = currentAPI
        self.previousFacade = getCode(modelPath: targetDirectory + Path("PersistentModels"), apiPath: targetDirectory + Path("PersistentAPIs"))
    }

    /// required for UnitTests to reset the code store after each test
    static func clear() {
        CodeStore.instance = nil
    }

    fileprivate func importEndpoints(_ apiPaths: [String]?, _ apiDirectory: Path, _ modifiables: inout [ModifiableFile]) {
        guard let apiPaths = apiPaths else {
            fatalError("No paths to endpoints provided.")
        }
        
        do {
            for endpointPath in apiPaths {
                let path = apiDirectory + Path(endpointPath)
                let content = try path.read(.utf8)
                let fileparser = try FileParser(contents: content, path: path)
                let code = try fileparser.parse()
                guard let types = WrappedTypes(types: code.types).modifiableFile else {
                    fatalError("Modifiable file could not be retrieved.")
                }
                modifiables.append(types)
            }
        } catch {
            fatalError("Endpoints could not be loaded.")
        }
    }
    
    fileprivate func importModels(_ mPaths: [String], _ modelDirectory: Path, _ modifiables: inout [ModifiableFile]) {
        do {
            for modelPath in mPaths {
                let path = modelDirectory + Path(modelPath)
                let content = try path.read(.utf8)
                let fileparser = try FileParser(contents: content, path: path)
                let code = try fileparser.parse()
                guard let types = WrappedTypes(types: code.types).modifiableFile else {
                    fatalError("Modifiable file could not be retrieved.")
                }
                
                modifiables.append(types)
            }
        } catch {
            fatalError("Models could not be loaded.")
        }
    }
    
    /// Reads and parses the source code inside of target directories
    /// - Parameters:
    ///   - modelPath: path to models
    ///   - apiPath: path to endpoints
    /// - Returns: List of parsed source code items
    private func getCode(modelPath: Path, apiPath: Path) -> [ModifiableFile]? {
        let modelDirectory = modelPath
        let apiDirectory = apiPath

        let modelPaths = try? FileManager.default
            .swiftFilesInDirectory(atPath: modelDirectory.string + "/")
            .sorted(by: { $0 == "_APIAliases.swift" || $0 == "APIAliases.swift" || $0 < $1 })
        let apiPaths = try? FileManager.default.swiftFilesInDirectory(atPath: apiDirectory.string + "/")
        let errorPaths = [
            modelPath.parent() + Path("_APIErrors.swift"),
            modelPath.parent() + Path("APIErrors.swift")
        ]

        guard let mPaths = modelPaths, !mPaths.isEmpty else {
            return nil
        }

        var modifiables: [ModifiableFile] = []
        
        importModels(mPaths, modelDirectory, &modifiables)

        importEndpoints(apiPaths, apiDirectory, &modifiables)

        do {
            for errorPath in errorPaths {
                if let content = try? errorPath.read(.utf8) {
                    let fileparser = try FileParser(contents: content, path: errorPath)
                    let code = try fileparser.parse()
                    guard let types = WrappedTypes(types: code.types).modifiableFile else {
                        fatalError("Modifiable file could not be retrieved.")
                    }
                    modifiables.append(types)
                }
            }
        } catch {
            fatalError("Error enum could not be loaded.")
        }

        return modifiables
    }

    /// Initializer for test cases
    /// - Parameters:
    ///   - previous: parsed source code items  of previous facade
    ///   - current: parsed source code items of current API
    static func initInstance(previous: [ModifiableFile], current: [ModifiableFile]) {
        if instance == nil {
            instance = CodeStore(previousFacade: previous, currentAPI: current)
        }
    }

    /// Initializer for executable
    /// - Parameter targetDirectory: path to source code files
    /// - Returns: initialized CodeStore
    static func initInstance(targetDirectory: Path) -> CodeStore {
        if instance == nil {
            instance = CodeStore(targetDirectory: targetDirectory)
        }
        
        return _instance
    }

    /// Singleton getter
    /// - Returns: returns singleton instance of CodeStore
    static func getInstance() -> CodeStore {
        _instance
    }
}
