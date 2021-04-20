import Foundation
import SourceryFramework
import SourceryRuntime
import PathKit

/// Entry point for PallidorMigrator package
public struct PallidorMigrator {
    let decoder = JSONDecoder()

    var codeStore: CodeStore?
    var targetDirectory: Path
    var migrationGuide: MigrationGuide
    var migrationSet: MigrationSet

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

        if migrationGuidePath == nil, migrationGuideContent == nil {
            fatalError("must specify migrationGuidePath or content")
        }

        if self.targetDirectory.exists {
            self.codeStore = CodeStore.initInstance(targetDirectory: self.targetDirectory)
        }

        if let migrationGuidePath = migrationGuidePath {
            let content = try Data(contentsOf: URL(fileURLWithPath: migrationGuidePath))
            self.migrationGuide = try decoder.decode(MigrationGuide.self, from: content)
        } else {
            guard let migrationGuideContent = migrationGuideContent,
                  let data = migrationGuideContent.data(using: .utf8) else {
                fatalError("migration guide content malformed")
            }
            self.migrationGuide = try decoder.decode(MigrationGuide.self, from: data)
        }

        self.migrationSet = self.migrationGuide.migrationSet
    }

    /// Creates the facade layer of the Swift Package.
    /// - Throws: Error if facade layer generation fails
    /// - Returns: List of URLs of files of facade layer
    public func buildFacade() throws -> [URL] {
        guard let codeStore = self.codeStore else {
            fatalError("Code Store could not be initialized.")
        }
        
        let modelDirectory = targetDirectory + Path("Models")
        let apiDirectory = targetDirectory + Path("APIs")

        let modelFacade = Facade(
            ModelTemplate.self,
            modifiables: codeStore.models(),
            targetDirectory: modelDirectory,
            migrationSet: migrationSet
        )
        let enumFacade = Facade(
            EnumTemplate.self,
            modifiables: codeStore.enums(),
            targetDirectory: modelDirectory,
            migrationSet: migrationSet
        )
        let apiFacade = Facade(
            APITemplate.self,
            modifiables: codeStore.endpoints(),
            targetDirectory: apiDirectory,
            migrationSet: self.migrationSet
        )
        
        let errorEnums: [ModifiableFile]
        
        if codeStore.hasFacade {
            guard let newErrors = codeStore.enum("OpenAPIError", scope: .current),
                  let previousErrors = codeStore.enum("OpenAPIError") else {
                fatalError("New or previous errors could not be retrieved.")
            }
            errorEnums = [newErrors, previousErrors]
        } else {
            guard let newErrors = codeStore.enum("OpenAPIError", scope: .current) else {
                fatalError("Previous errors could not be retrieved.")
            }
            errorEnums = [newErrors]
        }
        
        let errorFacade = ErrorFacade(modifiables: errorEnums, targetDirectory: targetDirectory)

        return [
            try modelFacade.persist(),
            try apiFacade.persist(),
            try enumFacade.persist(),
            try errorFacade.persist()
        ].flatMap { $0 }
    }
}
