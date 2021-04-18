//
//  DeleteMigration.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// Migration of a DeleteChange on a Modifiable
final class DeleteMigration: Migration {
    internal init(solvable: Bool, executeOn: Modifiable, change: DeleteChange) {
        super.init(solvable: solvable, executeOn: executeOn, change: change)
    }
    convenience init(solvable: Bool, executeOn: Modifiable, change: Changing) {
        guard let change = change as? DeleteChange else {
            fatalError("Change malformed: DeleteChange")
        }
        self.init(solvable: solvable, executeOn: executeOn, change: change)
    }
}
