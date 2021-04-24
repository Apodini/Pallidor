import Foundation
import SourceryFramework
import SourceryRuntime
import PathKit

/// Entry point for PallidorMigrator package
public struct PallidorMigrator {
    /// Errors thrown from PallidorMigrator initializer
    private enum PallidorMigratorError: Error {
        case invalidPath(String)
        case noMigrationGuide(String)
    }
    
    var store: Store
    var targetDirectory: Path
    var migrationGuide: MigrationGuide

    /// Entry for PallidorMigrator package
    /// - Parameters:
    ///   - targetDirectory: location string where Swift package should be located
    ///   - migrationGuidePath: path to migration guide if not directly inserted
    ///   - migrationGuideContent: content of migration guide if no external document is used.
    /// - Throws: Error if both migration guide parameters are missing or malformed
    public init(
        targetDirectory: String,
        migrationGuidePath: String? = nil,
        migrationGuideContent: String? = nil
    ) throws {
        self.targetDirectory = Path(targetDirectory)
        store = CodeStore()

        guard self.targetDirectory.isDirectory else {
            throw PallidorMigratorError.invalidPath("Encountered invalid path \(targetDirectory). The path must be a directory")
        }
        
        if let migrationGuideContent = migrationGuideContent {
            migrationGuide = try MigrationGuide.guide(with: migrationGuideContent).handled(in: store)
            return
        }
        
        if let migrationGuidePath = migrationGuidePath {
            migrationGuide = try MigrationGuide.guide(from: migrationGuidePath).handled(in: store)
            return
        }
        
        throw PallidorMigratorError.noMigrationGuide("Must specify migrationGuidePath or content")
    }

    /// Creates the facade layer of the Swift Package.
    /// - Throws: Error if facade layer generation fails
    /// - Returns: List of URLs of files of facade layer
    public func buildFacade() throws -> [URL] {
        store.collect(at: targetDirectory)
        
        let modelDirectory = targetDirectory + Path("Models")
        let apiDirectory = targetDirectory + Path("APIs")

        let migrationSet = migrationGuide.migrationSet
        
        let modelFacade = Facade(
            ModelTemplate.self,
            modifiables: store.models(),
            targetDirectory: modelDirectory,
            migrationSet: migrationSet
        )
        let enumFacade = Facade(
            EnumTemplate.self,
            modifiables: store.enums(),
            targetDirectory: modelDirectory,
            migrationSet: migrationSet
        )
        let apiFacade = Facade(
            APITemplate.self,
            modifiables: store.endpoints(),
            targetDirectory: apiDirectory,
            migrationSet: migrationSet
        )
        
        // error enum for .current scope is always rendered through MetaModelConverter of PallidorGenerator
        let errorEnums = Scope.allCases.compactMap { store.enum("OpenAPIError", scope: $0) }
        let errorFacade = ErrorFacade(modifiables: errorEnums, targetDirectory: targetDirectory)

        return [
            try modelFacade.persist(),
            try apiFacade.persist(),
            try enumFacade.persist(),
            try errorFacade.persist()
        ].flatMap { $0 }
    }
}
