// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// swiftlint:disable identifier_name
//
// ResourceReader.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// Reads resources in package
enum ResourceReader {
    /// Resources which are available in this package
    enum Resources: String {
        case HTTPAuthorizationModel, NetworkManagerModel, TestFileModel, PackageModel, TestManifestModel, LinuxMainModel
    }
    
    /// Reads the resource and returns it's value as String
    /// - Parameter resource: resources as stated in `Resources` enum
    /// - Returns: resource value as String
    static func read(_ resource: Resources) -> String {
        guard let fileURL = Bundle.module.url(forResource: resource.rawValue, withExtension: "md") else {
            fatalError("Could not locate the resource")
        }
        
        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            fatalError("Could not read the resource")
        }
    }
}
