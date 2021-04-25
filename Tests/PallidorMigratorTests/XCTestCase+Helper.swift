import XCTest
import Foundation
import PathKit
@testable import PallidorMigrator

extension XCTestCase {
    var noChange: String { """
   {
       "summary" : "Here would be a nice summary what changed between versions",
       "api-spec": "OpenAPI",
       "api-type": "REST",
       "from-version" : "0.0.1b",
       "to-version" : "0.0.2",
       "changes" : [
       ]
   }
   """ }
    
    func getMigrationResult(migration: String, target: String) -> ModifiableFile {
        let types = modifiableFile(from: target)
        XCTAssertNoThrow(try types.accept(.migrationSet(from: migration)))
        return types
    }
    
    
    func readResource(_ resource: String) -> String {
        guard let fileURL = Bundle.module.url(forResource: resource, withExtension: "md") else {
            XCTFail("Could not locate the resource")
            return ""
        }
        
        do {
            return String((try String(contentsOf: fileURL, encoding: .utf8)).dropLast())
        } catch {
            XCTFail("Could not read the resource")
        }
        
        return ""
    }
}

extension MigrationSet {
    /// All migration sets used throughout the target initialized through this static method.
    /// Injects the store accordingly to singleton of `TestCodeStore`
    static func migrationSet(from migrationGuideContent: String) -> MigrationSet {
        guard let migrationGuide = try? MigrationGuide.guide(with: migrationGuideContent) else {
            fatalError("Migration guide is malformed")
        }
        return migrationGuide.handled(in: TestCodeStore.instance).migrationSet
    }
}

class TestCodeStore: Store {
    /// Singleton of TestCodeStore
    static let instance = TestCodeStore()
    
    /// Store
    var previousFacade: [ModifiableFile]
    var currentAPI: [ModifiableFile]
    
    /// Test code store does not collect code from paths
    func collect(at targetDirectory: Path) {}
    
    /// Initializer
    private init() {
        previousFacade = []
        currentAPI = []
    }
    
    /// Used to prepare APIs for each test case. Injects the `Store` to each modifiable
    static func inject(previous: [ModifiableFile], current: [ModifiableFile]) {
        previous.forEach { $0.store = instance }
        current.forEach { $0.store = instance }
        
        instance.previousFacade = previous
        instance.currentAPI = current
    }
}
