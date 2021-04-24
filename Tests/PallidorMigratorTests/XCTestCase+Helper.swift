import XCTest
import Foundation
import SourceryFramework
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
    
    func getMigrationResult(migration: String, target: String) -> Modifiable {
        // swiftlint:disable force_try
        let fileParser = try! FileParser(contents: target)
        let code = try! fileParser.parse()
        guard let types = WrappedTypes(types: code.types).modifiableFile else {
            fatalError("Could not retrieve types.")
        }
        
        try! types.accept(.migrationSet(from: migration))
        // swiftlint:enable force_try
        
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
    static func migrationSet(from migrationGuideContent: String) -> MigrationSet {
        guard let migrationGuide = try? MigrationGuide.guide(with: migrationGuideContent) else {
            fatalError("Migration guide is malformed")
        }
        return migrationGuide.migrationSet
    }
}

extension CodeStore {
    static func inject(previous: [ModifiableFile], current: [ModifiableFile]) {
        instance.previousFacade = previous
        instance.currentAPI = current
    }
}
