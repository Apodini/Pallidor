//
//  MigrationGuide.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// represents the migration guide
class MigrationGuide: Decodable {
    /// textual summary of changes between versions
    var summary: String
    /// supported specification type
    var specType: SpecificationType
    /// supported service type
    var serviceType: ServiceType
    /// list of changes between versions
    var changes: [Change]
    /// previous version
    var versionFrom: SemanticVersion
    /// current version
    var versionTo: SemanticVersion
    
    /// The store that is handling the migration guide. Property set via `handled(in:)`
    private(set) var store: Store?

    private enum CodingKeys: String, CodingKey {
        case summary
        case changes
        case specType = "api-spec"
        case versionFrom = "from-version"
        case versionTo = "to-version"
        case serviceType = "api-type"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.summary = try container.decode(String.self, forKey: .summary)
        self.specType = try container.decode(SpecificationType.self, forKey: .specType)
        self.serviceType = try container.decode(ServiceType.self, forKey: .serviceType)
        self.versionFrom = SemanticVersion(versionString: try container.decode(String.self, forKey: .versionFrom))
        self.versionTo = SemanticVersion(versionString: try container.decode(String.self, forKey: .versionTo))

        self.changes = []

        var changesContainer = try container.nestedUnkeyedContainer(forKey: .changes)

        while !changesContainer.isAtEnd {
            [
                AddChange.self,
                RenameChange.self,
                DeleteChange.self,
                ReplaceChange.self
            ].forEach { changeType in
                if let value = try? changesContainer.decode(changeType) {
                    self.changes.append(value)
                }
            }
        }
    }
    
    /// Migration guides can only be initialized via `init(from decoder: Decoder)` throughout the project
    /// This method *must* be called right after init in order to inject the store to each modifiable
    func handled(in store: Store) -> MigrationGuide {
        self.store = store
        changes
            .filter { $0.changeType == .delete }
            .forEach { addDeleted(change: $0.typed(DeleteChange.self)) }
        
        return self
    }

    /// Identifies deleted items and prepares the facade for their deletion
    /// - Parameter change: change in which sth. was deleted
    // method requires that the current complexity to identify
    // all change types and their respective targets.
    // swiftlint:disable:next cyclomatic_complexity
    private func addDeleted(change: DeleteChange) {
        guard change.target == .signature else { return }
        var modifiable: Modifiable?
        switch change.object {
        case .endpoint(let endpoint):
            guard let endpointMod = store?.endpoint(endpoint.route) else {
                fatalError("Deleted endpoint \(endpoint.route) was not found in previous facade.")
            }
            modifiable = endpointMod
            store?.insertDeleted(modifiable: endpointMod)
        case .model(let model):
            guard let modelMod = store?.model(model.name) else {
                fatalError("Deleted model \(model.name) was not found in previous facade.")
            }
            modifiable = modelMod
            store?.insertDeleted(modifiable: modelMod)
        case .enum(let enumModel):
            guard let enumMod = store?.enum(enumModel.enumName) else {
                fatalError("Deleted enum \(enumModel.enumName) was not found in previous facade.")
            }
            modifiable = enumMod
            store?.insertDeleted(modifiable: enumMod)
        case .method(let method):
            guard let endpoint = store?.endpoint(method.definedIn, scope: .currentAPI) else {
                fatalError("Endpoint \(method.definedIn) was not found in current API.")
            }
            guard let wrappedMethod = store?.method(method.operationId) else {
                fatalError("Method is malformed - operation id might be invalid")
            }
            modifiable = wrappedMethod
            endpoint.methods.append(wrappedMethod)
        }

        modifiable?.accept(change: change)
    }
}

extension MigrationGuide {
    static func guide(with content: String) throws -> MigrationGuide {
        let data = content.data(using: .utf8) ?? Data()
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
    static func guide(from path: String) throws -> MigrationGuide {
        try JSONDecoder().decode(Self.self, from: try Data(contentsOf: URL(fileURLWithPath: path)))
    }
}

extension MigrationGuide {
    /// Activates and executes all migrations according to changes
    /// - Parameter modifiable: the modifiable which is about to be changed
    /// - Throws: error if change type could not be detected
    /// - Returns: the migrated modifiable
    func activate(for modifiable: ModifiableFile) throws {
        try changes.compactMap { change -> MigrationContainer? in
            if change.object.identifier == modifiable.id {
                return createMigration(change: change, target: modifiable)
            }
            return nil
        }.forEach { try $0.execute() }
    }
    
    /// creates the migration required to adapt the modifiable
    /// - Parameters:
    ///   - change: change that affects modifiable
    ///   - target: modifiable
    /// - Returns: migration which adapts the modifiable according to changes
    private func createMigration(change: Change, target: Modifiable) -> MigrationContainer {
        // solvable has to be checked on constraint conditions (aka. remove endpoint not supported)
        switch change.changeType {
        case .add, .rename:
            return MigrationContainer(solvable: true, executeOn: target, change: change)
        case .delete:
            if case .enum(let targetEnum) = change.object, let enumId = targetEnum.id {
                if case .case = change.target {
                    guard let facade = store?.enum(enumId) else {
                        fatalError("Enum was not found in previous facade.")
                    }
                    guard let target = target as? WrappedEnum else {
                        fatalError("Target is no enum.")
                    }
                    
                    let change = change.typed(DeleteChange.self)
                    target.cases.append(facade.cases.first(where: { $0.name == change.fallbackValue?.id })!)
                    return MigrationContainer(solvable: true, executeOn: target, change: change)
                }
            }
            return MigrationContainer(solvable: true, executeOn: target, change: change)
        case .replace:
            if case .method(let method) = change.object, case .signature = change.target, method.definedIn != target.id {
                guard let target = store?.method(method.operationId) else {
                    fatalError("Target replacement method was not found.")
                }
                return MigrationContainer(solvable: true, executeOn: target, change: change)
            }
            return MigrationContainer(solvable: true, executeOn: target, change: change)
        case .nil:
            fatalError("No change type detected")
        }
    }
}
