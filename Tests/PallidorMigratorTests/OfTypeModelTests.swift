// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery. 
// swiftlint:disable identifier_name
import XCTest
@testable import PallidorMigrator

class OfTypeModelTests: PallidorMigratorXCTestCase {
    func testOfTypeModelNoChange() {
        let migrationResult = migration(.EmptyGuide, target: .ModelOfType)
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelOfType))
    }
    
    func testOfTypeModelRenamed() {
        let migrationResult = migration(.RenameOfTypeModelChange, target: .ModelOfTypeRenamed)
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelOfTypeRenamed))
    }
    
    func testOfTypeModelDeletedCase() {
        let migrationResult = migration(.DeleteOfTypeEnumCaseChange, target: .ModelOfTypeFacade)
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelOfTypeDeletedCase))
    }
        
    func testOfTypeModelDeleted() {
        let facade = modifiable(.ModelOfTypeFacade)
        TestCodeStore.inject(previous: [facade], current: [])
    
        _ = migration(.DeleteOfTypeChange, target: .ModelPlaceholder)
        
        guard let migrationResult = TestCodeStore.instance.model(facade.id) else {
            fatalError("Migration failed.")
        }
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelOfTypeDeleted))
    }
    
    func testOfTypeModelReplaced() {
        let migrationResult = migration(.ReplaceOfTypeModelChange, target: .ModelOfTypeFacade)
        
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelOfTypeReplaced))
    }
    
    static var allTests = [
        ("testOfTypeModelNoChange", testOfTypeModelNoChange),
        ("testOfTypeModelRenamed", testOfTypeModelRenamed),
        ("testOfTypeModelDeletedCase", testOfTypeModelDeletedCase),
        ("testOfTypeModelDeleted", testOfTypeModelDeleted),
        ("testOfTypeModelReplaced", testOfTypeModelReplaced)
    ]
}
