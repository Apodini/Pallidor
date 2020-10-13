//
//  Migrator.swift
//
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import PathKit
import PallidorMigrator

/// Responsible for creating the facade of an OpenAPI library according to a migration guide.
struct Migrator {

    /// Migration handler
    var migrator : PallidorMigrator
    
    internal init(targetDirectory: String, migrationGuidePath: String) throws {
        migrator = try PallidorMigrator(targetDirectory: targetDirectory, migrationGuidePath: migrationGuidePath)
    }
    
    
    /// Creates the facade and adapts it according to the migration guide
    /// - Throws: Error if migration fails
    /// - Returns: a list of file URLs of the generated facade files
    func buildFacade() throws -> [URL] {
        try migrator.buildFacade()
    }
}
