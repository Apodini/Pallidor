//
//  MigrationSet.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// represents all migrations resulting from the migration guide
class MigrationSet {
    /// guide from which this set is generated
    private var guide: MigrationGuide
    /// list of migrations to be executed
    private var migrations: [Migrating]

    init(guide: MigrationGuide) {
        self.guide = guide
        self.migrations = [Migrating]()
    }

    /// Activates and executes all migrations according to changes from migration guide
    /// - Parameter modifiable: the modifiable which is about to be changed
    /// - Throws: error if change type could not be detected
    /// - Returns: the migrated modifiable
    func activate(for modifiable: ModifiableFile) throws {
        for change in guide.changes {
            switch change.object {
            case .endpoint(let endpoint):
                if endpoint.route == modifiable.id {
                    migrations.append(createMigration(change: change, target: modifiable))
                }
            case .method(let method):
                if method.definedIn == modifiable.id {
                    migrations.append(createMigration(change: change, target: modifiable))
                }
            case .model(let model):
                if model.id == modifiable.id {
                    migrations.append(createMigration(change: change, target: modifiable))
                }

            case .enum(let enumModel):
                if enumModel.id == modifiable.id {
                    migrations.append(createMigration(change: change, target: modifiable))
                }
            }
        }

        for mig in migrations {
            try mig.execute()
        }
    }
    
    /// creates the migration required to adapt the modifiable
    /// - Parameters:
    ///   - change: change that affects modifiable
    ///   - target: modifiable
    /// - Returns: migration which adapts the modifiable according to changes
    private func createMigration(change: Change, target: Modifiable) -> Migrating {
        switch change.changeType {
        case .add:
            // solvable has to be checked on constraint conditions (aka. remove endpoint not supported)
            return AddMigration(solvable: true, executeOn: target, change: change)
        case .rename:
            // solvable has to be checked on constraint conditions (aka. remove endpoint not supported)
            return RenameMigration(solvable: true, executeOn: target, change: change)
        case .delete:
            return createDeleteMigration(change, target)
        case .replace:
            // solvable has to be checked on constraint conditions (aka. remove endpoint not supported)
            if case .method(let method) = change.object, case .signature = change.target, method.definedIn != target.id {
                guard let target = CodeStore.instance.method(method.operationId) else {
                    fatalError("Target replacement method was not found.")
                }
                return ReplaceMigration(solvable: true, executeOn: target, change: change)
            }
            return ReplaceMigration(solvable: true, executeOn: target, change: change)
        case .nil:
            fatalError("No change type detected")
        }
    }

    fileprivate func createDeleteMigration(_ change: Change, _ target: Modifiable) -> Migrating {
        if case .enum(let targetEnum) = change.object, let enumId = targetEnum.id {
            if case .case = change.target {
                guard let facade = CodeStore.instance.enum(enumId) else {
                    fatalError("Enum was not found in previous facade.")
                }
                guard let target = target as? WrappedEnum else {
                    fatalError("Target is no enum.")
                }
                
                let change = change.typed(DeleteChange.self)
                // Change must specify a fallback value due to migration guide constraints.
                // swiftlint:disable:next force_unwrapping
                target.cases.append(facade.cases.first(where: { $0.name == change.fallbackValue!.id! })!)
                return DeleteMigration(solvable: true, executeOn: target, change: change)
            }
        }
        return DeleteMigration(solvable: true, executeOn: target, change: change)
    }
}
