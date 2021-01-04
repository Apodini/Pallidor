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
    var migrator: PallidorMigrator
    
    internal init(targetDirectory: String, migrationGuidePath: String? = nil) throws {
        guard let migrationGuidePath = migrationGuidePath else {
            migrator = try PallidorMigrator(targetDirectory: targetDirectory, migrationGuideContent: emptyMigrationGuide)
            return
        }
        migrator = try PallidorMigrator(targetDirectory: targetDirectory, migrationGuidePath: migrationGuidePath)
    }
    
    
    /// default empty migration guide that is used on the first integration
    private let emptyMigrationGuide = """
    {
           "summary" : "empty guide",
           "api-spec": "OpenAPI",
           "api-type": "REST",
           "from-version" : "0.0.0",
           "to-version" : "0.0.0",
           "changes" : []
    }
    """
    
    
    /// Creates the facade and adapts it according to the migration guide
    /// - Throws: Error if migration fails
    /// - Returns: a list of file URLs of the generated facade files
    func buildFacade() throws -> [URL] {
        try migrator.buildFacade()
    }
}
