//
//  ErrorFacade.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import PathKit

/// Not handled via migration guide, but through local comparison of enums
class ErrorFacade: Facade {
    init(modifiables: [ModifiableFile], targetDirectory: Path) {
        super.init(ErrorEnumTemplate.self, modifiables: modifiables, targetDirectory: targetDirectory, migrationSet: nil)
    }
    
    /// Compares `APIErrors` enum cases, applies changes if any, persists the files and returns back the path urls of each file
    /// - Throws: error if writing fails
    /// - Returns: List of file URLs
    override func persist() throws -> [URL] {
        guard let newErrorEnum = modifiables.first as? WrappedEnum else {
            fatalError("Could not detect enum.")
        }

        let path = targetDirectory + Path("APIErrors.swift")
        if modifiables.count == 2 {
            guard let facadeErrorEnum = modifiables[1] as? WrappedEnum else {
                fatalError("Could not detect error enum.")
            }
            for targetCase in newErrorEnum.compareCases(facadeErrorEnum) {
                facadeErrorEnum.accept(change: targetCase)
            }
            guard let url = try template.write(facadeErrorEnum, to: path) else {
                fatalError("Attempted to write empty Error Enum to file.")
            }
            return [url]
        }
        
        guard let url = try template.write(newErrorEnum, to: path) else {
            fatalError("Attempted to write empty Error Enum to file.")
        }

        return [url]
    }
}
