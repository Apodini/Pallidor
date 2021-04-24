//
//  Modifiable.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// Protocol all source code types (structs, enums, etc.) must conform to
protocol Modifiable: AnyObject {
    /// identifier of source code type
    var id: String { get }
    /// true if migration affected this modifiable
    var modified: Bool { get set }
    /// annotation for this modifiable (if available)
    var annotation: Annotation? { get set }

    /// Modifies the source code type according to the change as stated in migration guide.
    /// Is called from within the migration process of `MigrationSet`
    /// - Parameter change: change as stated in migration guide
    func accept(change: Change)
}

/// Protocol for modifiables that are persisted in a specific file, e.g. APIs, Models or enums.
protocol ModifiableFile: Modifiable {
    var fileName: String { get }
    
    /// The store where this `ModifiableFile` is being handled. Property set through `accept(_:)`
    /// After setting the property, this `ModifiableFile` passes the reference to `Modifiable` properties that need access to the `Store`
    var store: Store? { get set }
    
    /// Accepts the changes of `migrationSet`. The modifiables additionally gets the `Store` injected from the migration set
    /// - Parameter migrationSet: set of changes
    /// - Throws: error if any of the changes is not supported for migration
    func accept(_ migrationSet: MigrationSet) throws
}

extension ModifiableFile {
    func accept(_ migrationSet: MigrationSet) throws {
        self.store = migrationSet.store
        try migrationSet.activate(for: self)
    }
}
