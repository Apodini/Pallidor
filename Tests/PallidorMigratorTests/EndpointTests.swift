// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery. File exceeds normal length due to migration guides.
// Line length exceeds due to convert/revert definition in migration guide
// swiftlint:disable identifier_name
import XCTest
@testable import PallidorMigrator

class EndpointTests: PallidorMigratorXCTestCase {
    func testEndpointRenamed() {
        let migrationResult = migration(.RenameEndpointChange, target: .PetEndpointRenamed)
        let result = APITemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamed))
    }
        
    func testRenamedAndAddMethod() {
        let facade = modifiable(.PetEndpointFacadeAddMethod)
        TestCodeStore.inject(previous: [facade], current: [])
        let migrationResult = migration(.RenameEndpointChange, target: .PetEndpointRenamed)
        
        let result = APITemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamed))
    }
    
    func testDeleted() {
        let facade = modifiable(.PetEndpointFacade)
        TestCodeStore.inject(previous: [facade], current: [])
        
        /// irrelevant for deleted migration
        _ = migration(.DeleteEndpointChange, target: .EndpointPlaceholder)
        guard let migrationResult = TestCodeStore.instance.endpoint(facade.id, scope: .currentAPI) else {
            fatalError("Migration failed.")
        }
        
        let result = APITemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeDeleted))
    }
    
    /// method `updatePet()` is renamed to `updateMyPet()`
    /// parameter changed, return value remain the same
    func testRenameMethodAndChangeContentBodyChange() {
        let migrationResult = migration(.RenameMethodAndChangeContentBodyChange, target: .PetEndpointRenamedMethodAndContentBody)
        let result = APITemplate().render(migrationResult)
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamedMethodAndContentBody)
        )
    }
    
    static var allTests = [
        ("testDeleted", testDeleted),
        ("testEndpointRenamed", testEndpointRenamed),
        ("testRenameMethodAndChangeContentBodyChange", testRenameMethodAndChangeContentBodyChange)
    ]
}
