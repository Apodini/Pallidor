import Foundation
import PathKit

protocol Store: AnyObject {
    /// parsed source code located in facade folders
    var previousFacade: [ModifiableFile] { get set }
    /// parsed source code located in API folders
    var currentAPI: [ModifiableFile] { get set }
    
    /// Collects source code from Models and APIs folders, and the respective error enums
    /// - Parameter targetDirectory: path to source code files
    func collect(at targetDirectory: Path)
}

/// Default implementations for code accessing and manipulation
extension Store {
    /// inserts a new modifiable into the current api list (for getting deleted source code out of facade into current api)
    /// - Parameter modifiable: deleted source code from facade
    func insertDeleted(modifiable: ModifiableFile) {
        currentAPI.append(modifiable)
    }

    /// Inserts a modifiable into the code store
    /// - Parameters:
    ///   - modifiable: modifiable to insert
    ///   - scope: where the modifiable file should be inserted
    func insert(modifiable: ModifiableFile, in scope: Scope = .previousFacade) {
        scope == .current ? currentAPI.append(modifiable) : previousFacade.append(modifiable)
    }

    /// Retrieves a method by `id`
    /// - Parameters:
    ///   - id: identifier of method (e.g. name)
    ///   - scope: where the method should be retrieved from
    /// - Returns: Method if available
    func method(_ id: String, scope: Scope = .previousFacade) -> WrappedMethod? {
        endpoints(scope: scope)
            .flatMap { $0.methods }
            .first { $0.id == id }
    }

    /// Retrieves a model by `id`
    /// - Parameters:
    ///   - id: identifier of model (e.g. name)
    ///   - scope: where the model should be retrieved from
    /// - Returns: Model if available
    func model(_ id: String, scope: Scope = .previousFacade) -> WrappedClass? {
        models(scope: scope).first { $0.id == id }
    }

    /// Retrieves an Enum by `id`, including error enums
    /// - Parameters:
    ///   - id: identifier of enum (e.g. name)
    ///   - scope: where the enum should be retrieved from
    /// - Returns: Enum if available
    func `enum`(_ id: String, scope: Scope = .previousFacade) -> WrappedEnum? {
        modifiable(with: id, WrappedEnum.self, scope: scope)
    }

    /// Retrieves an Endpoint by `id`
    /// - Parameters:
    ///   - id: identifier of endpoint (e.g. top level route)
    ///   - scope: where the endpoint should be retrieved from
    /// - Returns: Endpoint if available
    func endpoint(_ id: String, scope: Scope = .previousFacade) -> WrappedStruct? {
        endpoints(scope: scope).first { $0.id == id }
    }

    /// Retrieves all enums from Store, except of OpenAPIError ones
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

fileprivate extension Store {
    /// Retrieves modifiable files of a certain type
    /// - Parameters:
    ///   - type: type of modifiables
    ///   - scope: where the modifiables should be retrieved from
    /// - Returns: list of modifiables
    func modifiables<M: ModifiableFile>(_ type: M.Type = M.self, scope: Scope = .current) -> [M] {
        (scope == .current ? currentAPI : previousFacade)
            .filter { $0 is M } as? [M] ?? []
    }
    
    func modifiable<M: ModifiableFile>(with id: String, _ type: M.Type = M.self, scope: Scope = .previousFacade) -> M? {
        modifiables(M.self, scope: scope).first { $0.id == id }
    }
}
