//
//  CodeStore+StoreAccess.swift
//
//  Created by Andre Weinkoetz on 10/10/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation

/// extension of CodeStore for CodeStore content manipulation & access
extension CodeStore {
    /// inserts a new modifiable into the current api list (for getting deleted source code out of facade into current api)
    /// - Parameter modifiable: deleted source code from facade
    func insertDeleted(modifiable: ModifiableFile) {
        currentAPI.append(modifiable)
    }

    /// Inserts a modifiable into the code store
    /// - Parameters:
    ///   - modifiable: modifiable to insert
    ///   - scope: where the modifiable file should be inserted
    func insert(modifiable: ModifiableFile, in scope: Scope = .previous) {
        guard assertAccess(scope) else {
            fatalError("Tried to insert modifiable in previous facade which is nil.")
        }
        scope == .current ? currentAPI.append(modifiable) : previousFacade?.append(modifiable)
    }

    /// Retrieves a method by `id`
    /// - Parameters:
    ///   - id: identifier of method (e.g. name)
    ///   - scope: where the method should be retrieved from
    /// - Returns: Method if available
    func method(_ id: String, scope: Scope = .previous) -> WrappedMethod? {
        endpoints(scope: scope)
            .flatMap { $0.methods }
            .first { $0.id == id }
    }

    /// Retrieves a model by `id`
    /// - Parameters:
    ///   - id: identifier of model (e.g. name)
    ///   - scope: where the model should be retrieved from
    /// - Returns: Model if available
    func model(_ id: String, scope: Scope = .previous) -> WrappedClass? {
        models(scope: scope).first { $0.id == id }
    }

    /// Retrieves an Enum by `id`, including error enums
    /// - Parameters:
    ///   - id: identifier of enum (e.g. name)
    ///   - scope: where the enum should be retrieved from
    /// - Returns: Enum if available
    func `enum`(_ id: String, scope: Scope = .previous) -> WrappedEnum? {
        modifiable(with: id, WrappedEnum.self, scope: scope)
    }

    /// Retrieves an Endpoint by `id`
    /// - Parameters:
    ///   - id: identifier of endpoint (e.g. top level route)
    ///   - scope: where the endpoint should be retrieved from
    /// - Returns: Endpoint if available
    func endpoint(_ id: String, scope: Scope = .previous) -> WrappedStruct? {
        endpoints(scope: scope).first { $0.id == id }
    }

    /// Retrieves all enums from CodeStore, except of OpenAPIError ones
    /// - Parameter scope: where the enums should be retrieved from
    /// - Returns: List of all enums
    func enums(scope: Scope = .current) -> [WrappedEnum] {
        modifiables(WrappedEnum.self, scope: scope).filter { $0.localName.removePrefix != "OpenAPIError" }
    }
    
    /// Retrieves all endpoints
    /// - Parameter scope: where the endpoints should be retrieved from
    /// - Returns: List of all endpoints
    func endpoints(scope: Scope = .current) -> [WrappedStruct] {
        modifiables(WrappedStruct.self, scope: scope)
    }
    
    /// Retrieves all models
    /// - Parameter scope: where the models should be retrieved from
    /// - Returns: List of all models
    func models(scope: Scope = .current) -> [WrappedClass] {
        modifiables(WrappedClass.self, scope: scope)
    }
}

fileprivate extension CodeStore {
    /// Asserts access to search for modifiables
    func assertAccess(_ scope: Scope) -> Bool {
        scope == .current || previousFacade != nil
    }
    
    /// Retrieves modifiable files of a certain type
    /// - Parameters:
    ///   - type: type of modifiables
    ///   - scope: where the modifiables should be retrieved from
    /// - Returns: list of modifiables
    func modifiables<M: ModifiableFile>(_ type: M.Type = M.self, scope: Scope = .current) -> [M] {
        guard assertAccess(scope) else {
            fatalError("Tried to search in previous facade which is not initialized.")
        }
        return (scope == .current ? currentAPI : previousFacade)?
            .filter { $0 is M } as? [M] ?? []
    }
    
    func modifiable<M: ModifiableFile>(with id: String, _ type: M.Type = M.self, scope: Scope = .previous) -> M? {
        modifiables(M.self, scope: scope).first { $0.id == id }
    }
}
