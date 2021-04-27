//
//  MigrationContainer.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// Migration container
class MigrationContainer {
    /// Error thrown from `MigrationContainer`
    private enum RuleError: Error {
        case notSupported(msg: String)
    }
    /// Indicates whether the migration can be solved
    var solvable: Bool
    /// The change that has to be performed
    var change: Change
    /// modifiable where the change will be executed
    var executeOn: Modifiable
    
    init(solvable: Bool, executeOn: Modifiable, change: Change) {
        self.solvable = solvable
        self.change = change
        self.executeOn = executeOn
    }

    /// Executes the change on `executeOn`
    func execute() throws {
        guard solvable else {
            throw RuleError.notSupported(msg: "Unsupported rule: \(executeOn.id) modified by \(change.changeType)")
        }
        executeOn.accept(change: change)
    }
}
