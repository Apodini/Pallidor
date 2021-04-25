// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery.
// swiftlint:disable identifier_name
import XCTest
@testable import PallidorMigrator

class EnumTests: PallidorMigratorXCTestCase {
    func testNoChangeEnum() {
        let migrationResult = migration(.EmptyGuide, target: .EnumTimeMode)
        let result = EnumTemplate().render(migrationResult)

        
        XCTAssertEqual(result, expectation(.ResultEnumTimeMode))
    }

    func testDeletedCase() {
        let facade = modifiable(.EnumTimeModeFacade)
        TestCodeStore.inject(previous: [facade], current: [])
        
        let migrationResult = migration(.DeleteEnumCaseChange, target: .EnumTimeModeDeletedCase)
        
        let result = EnumTemplate().render(migrationResult)

        XCTAssertEqual(result, expectation(.ResultEnumTimeModeDeletedCase))
    }

    func testDeleted() {
        let facade = modifiable(.EnumTimeModeFacade)
        TestCodeStore.inject(previous: [facade], current: [])
        
        // irrelevant result
        _ = migration(.DeleteEnumChange, target: .EnumPlaceholder)
        
        guard let migrationResult = TestCodeStore.instance.enum(facade.id, scope: .currentAPI) else {
            fatalError("Migration failed.")
        }
        let result = EnumTemplate().render(migrationResult)
        
        XCTAssertEqual(result, expectation(.ResultEnumTimeModeDeleted))
    }
    
    func testRenamed() {
        let migrationResult = migration(.RenameEnumChange, target: .EnumTimeModeRenamed)
        let result = EnumTemplate().render(migrationResult)

        XCTAssertEqual(result, expectation(.ResultEnumTimeModeRenamed))
    }

    func testReplaced() {
        let migrationResult = migration(.ReplaceEnumChange, target: .EnumMessageLevelFacade)
        let result = EnumTemplate().render(migrationResult)

        XCTAssertEqual(result, expectation(.ResultEnumMessageLevelReplaced))
    }
    
        
    static var allTests = [
        ("testNoChangeEnum", testNoChangeEnum),
        ("testDeleted", testDeleted),
        ("testDeletedCase", testDeletedCase),
        ("testRenamed", testRenamed),
        ("testReplaced", testReplaced)
    ]
}
