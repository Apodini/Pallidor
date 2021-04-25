// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery. File exceeds normal length due to migration guides.
// Line length exceeds due to convert/revert definition in migration guide
// swiftlint:disable identifier_name line_length
import XCTest
@testable import PallidorMigrator

class MethodIntegrationTests: PallidorMigratorXCTestCase {
    func testRenamedMethodAndReplacedAndDeletedParameter() {
        let migrationResult = migration(.RenameMethodAndReplaceAndDeleteParameterChange, target: .PetEndpointRenamedMethodAndReplacedParameter)
        
        let result = APITemplate().render(migrationResult)
        
        XCTAssertEqual(
            result,
            expectation(.ResultPetEndpointFacadeRenamedMethodAndReplacedDeletedParameter)
        )
    }
        
    func testRenameMethodAndAddedParameter() {
        let migrationResult = migration(.RenameMethodAndAddParameterChange, target: .PetEndpointRenamedMethodAndAddedParameter)
        let result = APITemplate().render(migrationResult)
        
        XCTAssertEqual(result, expectation(.ResultPetEndpointFacadeRenamedMethodAndAddedParameter))
    }
    
    func testRenamedMethodAndRenameParameter() {
        let migrationResult = migration(.RenameMethodAndRenameParameterChange, target: .PetEndpointRenamedMethodAndRenamedParameter)
        let result = APITemplate().render(migrationResult)
        
        XCTAssertEqual(
            result,
            expectation(.ResultPetEndpointFacadeRenamedMethodAndRenamedParameter)
        )
    }

    func testRenamedMethodAndDeletedParameter() {
        let migrationResult = migration(.RenameMethodAndDeleteParameterChange, target: .PetEndpointRenamedMethodAndDeletedParameter)
        let result = APITemplate().render(migrationResult)

        XCTAssertEqual(
            result,
            expectation(.ResultPetEndpointFacadeRenamedMethodAndDeletedParameter)
        )
    }

    func testRenamedMethodAndReplacedReturnValue() {
        let migrationResult = migration(.RenameMethodAndReplacedReturnValueChange, target: .PetEndpointRenamedMethodAndReplacedReturnValue)
        let result = APITemplate().render(migrationResult)

        XCTAssertEqual(
            result,
            expectation(.ResultPetEndpointRenamedMethodAndReplacedReturnValue)
        )
    }
    
    static var allTests = [
        ("testRenameMethodAndAddedParameter", testRenameMethodAndAddedParameter),
        ("testRenamedMethodAndRenameParameter", testRenamedMethodAndRenameParameter),
        ("testRenamedMethodAndDeletedParameter", testRenamedMethodAndDeletedParameter),
        ("testRenamedMethodAndReplacedReturnValue", testRenamedMethodAndReplacedReturnValue),
        ("testRenamedMethodAndReplacedAndDeletedParameter", testRenamedMethodAndReplacedAndDeletedParameter)
    ]
}
