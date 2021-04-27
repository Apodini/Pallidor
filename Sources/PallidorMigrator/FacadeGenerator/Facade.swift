//
//  Facade.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import PathKit

/// Used to persist modifiable files after the changes specified in the migration guide
class Facade {
    /// code template used to apply to modifiables
    let template: CodeTemplate
    /// list of modifiable files
    let modifiables: [ModifiableFile]
    /// target directory
    let targetDirectory: Path
    /// migration guide if available
    let migrationGuide: MigrationGuide?
    
    init(_ template: CodeTemplate.Type, modifiables: [ModifiableFile], targetDirectory: Path, migrationGuide: MigrationGuide?) {
        self.template = template.init()
        self.modifiables = modifiables
        self.targetDirectory = targetDirectory
        self.migrationGuide = migrationGuide
    }
    
    /// Applies changes to modifiables, persists the files and returns back the path urls of each file
    /// - Throws: error if writing fails
    /// - Returns: List of file URLs
    func persist() throws -> [URL] {
        guard let migrationGuide = migrationGuide else {
            fatalError("Migration guide not initialized")
        }
        
        return try modifiables
            .map { modifiable in
                try modifiable.accept(migrationGuide)
                
                let target = targetDirectory.persistentPath + Path("\(modifiable.fileName).swift")
                
                guard let result = try? template.write(modifiable, to: target) else {
                    fatalError("Could not write file to target directory.")
                }
                return result
            }
    }
}
