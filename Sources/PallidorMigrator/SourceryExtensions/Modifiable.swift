//
//  Modifiable.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// Protocol all source code types (structs, enums, etc.) must conform to
protocol Modifiable: class {
    /// identifier of source code type
    var id: String { get }
    /// true if migration affected this modifiable
    var modified: Bool { get set }
    /// annotation for this modifiable (if available)
    var annotation: Annotation? { get set }

    /// Modifies the source code type according to the change as stated in migration guide.
    /// Is called from within the migration process of `MigrationSet`
    /// - Parameter change: change as stated in migration guide
    func modify(change: Change)
}

/// Protocol for modifiables that are persisted in a specific file, e.g. APIs, Models or enums.
protocol ModifiableFile: Modifiable {
    var fileName: String { get }
}

extension ModifiableFile {
    
    /// Accepts the changes of `migrationSet`
    /// - Parameter migrationSet: set of changes
    /// - Throws: error if any of the changes is not supported for migration
    func accept(_ migrationSet: MigrationSet) throws {
        try migrationSet.activate(for: self)
    }
}

