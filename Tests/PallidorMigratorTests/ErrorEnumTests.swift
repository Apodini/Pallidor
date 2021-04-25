// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery.
// swiftlint:disable identifier_name
import XCTest
@testable import PallidorMigrator

class ErrorEnumTests: PallidorMigratorXCTestCase {
    func testErrorEnumNoChange() {
        let migrationResult = migration(.EmptyGuide, target: .ErrorEnum)
        let result = ErrorEnumTemplate().render(migrationResult)
        XCTAssertEqual(result, expectation(.ResultErrorEnum))
    }
    
    func testErrorEnumDeletedCase() {
        guard let enumDeletedCase = migration(.EmptyGuide, target: .ErrorEnumDeletedCase) as? WrappedEnum else {
            fatalError("Migration failed.")
        }

        guard let enumFacade = migration(.EmptyGuide, target: .ResultErrorEnumDeletedCase) as? WrappedEnum else {
            fatalError("Migration failed.")
        }
        
        let changes = enumDeletedCase.compareCases(enumFacade)
        
        for change in changes {
            enumFacade.accept(change: change)
        }
        
        let result = ErrorEnumTemplate().render(enumFacade)
        
        XCTAssertEqual(result, expectation(.ResultErrorEnumDeletedCase))
    }
    
    func testErrorEnumAddCase() {
        guard let enumAddedCases = migration(.EmptyGuide, target: .ErrorEnumAddedCase) as? WrappedEnum else {
            fatalError("Migration failed.")
        }

        guard let enumFacade = migration(.EmptyGuide, target: .ErrorEnumFacadeAddedCase) as? WrappedEnum else {
            fatalError("Migration failed.")
        }
        
        let changes = enumAddedCases.compareCases(enumFacade)
        
        for change in changes {
            enumFacade.accept(change: change)
        }
        
        let result = ErrorEnumTemplate().render(enumFacade)
        
        XCTAssertEqual(result, expectation(.ResultErrorEnumAddedCase))
    }
    
    
    static var allTests = [
        ("testErrorEnumDeletedCase", testErrorEnumDeletedCase),
        ("testErrorEnumNoChange", testErrorEnumNoChange),
        ("testErrorEnumAddCase", testErrorEnumAddCase)
    ]
}
