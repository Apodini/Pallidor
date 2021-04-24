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
        case previousFacade
    }
    
    /// Singleton of code store instance, by default empty
    public static var instance = CodeStore()
    
    /// parsed source code located in facade folders
    var previousFacade: [ModifiableFile]
    /// parsed source code located in API folders
    var currentAPI: [ModifiableFile]

    /// Returns whether the previous facade contains files
    var hasFacade: Bool {
        !previousFacade.isEmpty
    }
    
    private init() {
        previousFacade = []
        currentAPI = []
    }

    /// Collects source code form Models and APIs folders, and the respective error enums
    /// - Parameter targetDirectory: path to source code files
    func collect(at targetDirectory: Path) {
        guard let currentAPI = getCode(
            modelPath: targetDirectory + Path("Models"),
            apiPath: targetDirectory + Path("APIs")
        ) else {
            fatalError("Current API must be present.")
        }
        
        self.currentAPI = currentAPI
        self.previousFacade = getCode(modelPath: targetDirectory + Path("PersistentModels"), apiPath: targetDirectory + Path("PersistentAPIs")) ?? []
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
        
        let modelPaths = FileManager
            .swiftFilesInDirectory(atPath: modelDirectory.string + "/")
            .sorted(by: { $0 == "_APIAliases.swift" || $0 == "APIAliases.swift" || $0 < $1 })
        let apiPaths = FileManager.swiftFilesInDirectory(atPath: apiDirectory.string + "/")
        let errorPaths = [
            modelPath.parent() + Path("_APIErrors.swift"),
            modelPath.parent() + Path("APIErrors.swift")
        ]
        
        guard !modelPaths.isEmpty else {
            return nil
        }
        
        var modifiables: [ModifiableFile] = []
        
        importModels(modelPaths, modelDirectory, &modifiables)

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
}
