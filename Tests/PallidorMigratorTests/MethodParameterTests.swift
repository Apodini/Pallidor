// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery. File exceeds normal length due to migration guides.
// Line length exceeds due to convert/revert definition in migration guide
// swiftlint:disable identifier_name type_body_length file_length line_length
import XCTest
@testable import PallidorMigrator

class MethodParameterTests: PallidorMigratorXCTestCase {
    func testReplacedMNParametersOfMethod() {
        let facade = modifiable(.PetEndpointFacadeReplacedMethod)
        let current = modifiable(.PetEndpointReplaceParameter32)
        
        TestCodeStore.inject(previous: [facade], current: [current])

        _ = migration(.ReplaceMNParameterChange, target: .PetEndpointReplaceParameter32)
        
        guard let migratedModifiable = TestCodeStore.instance.endpoint("/pet", scope: .currentAPI) else {
            fatalError("Migration failed.")
        }
        
        let result = APITemplate().render(migratedModifiable)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacade32ParameterChange))
    }
    
    func testReplacedM1ParametersOfMethod() {
        let facade = modifiable(.PetEndpointFacadeReplacedMethod)
        let current = modifiable(.PetEndpointReplaceParameterMN)
        TestCodeStore.inject(previous: [facade], current: [current])
        
        _ = migration(.ReplaceM1ParameterChange, target: .PetEndpointReplaceParameterMN)
        
        guard let migratedModifiable = TestCodeStore.instance.endpoint("/pet", scope: .currentAPI) else {
            fatalError("Migration failed.")
        }
        
        let result = APITemplate().render(migratedModifiable)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeM1ParameterChange))
    }
    
    func testReplaced1NParametersOfMethod() {
        let facade = modifiable(.PetEndpointFacadeReplacedMethod)
        let current = modifiable(.PetEndpointReplaceParameterMN)
        TestCodeStore.inject(previous: [facade], current: [current])
        
        _ = migration(.Replace1NParameterChange, target: .PetEndpointReplaceParameterMN)
        
        guard let migratedModifiable = TestCodeStore.instance.endpoint("/pet", scope: .currentAPI) else {
            fatalError("Migration failed.")
        }
        
        let result = APITemplate().render(migratedModifiable)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacade1NParameterChange))
    }

    /// has added param `status: String` to `updatePet()`
    func testAddedParameter() {
        let migrationResult = migration(.AddParameterChange, target: .PetEndpointAddedParameter)
        let result = APITemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeAddedParameter))
    }
    
    func testDeletedParameter() {
        let migrationResult = migration(.DeleteParameterChange, target: .UserEndpointDeletedParameter)
        let result = APITemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultUserEndpointFacadeDeletedParameter))
    }
    
    func testRenamedParameter() {
        let migrationResult = migration(.RenameMethodParameterChange, target: .PetEndpointRenamedParameter)
        let result = APITemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamedParameter))
    }
    
    /// replaced param `petId: Int64` with `betterId: Double` in `updatePetWithForm()`
    func testReplacedParameter() {
        let migrationResult = migration(.ReplaceMethodParameterChange, target: .PetEndpointReplacedParameter)
        let result = APITemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeReplacedParameter))
    }
    
    /// optional param `petId: Int64` is now  required
    func testRequiringParameter() {
        let migrationResult = migration(.RequiringMethodParameterChange, target: .PetEndpointRequiringParameter)
        let result = APITemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRequiredParameter))
    }
   
    /// method `placeOrder` now has content-type of `Customer` instead of `Order`
    func testReplacedContentBodyStoreEndpoint() {
        let migrationResult = migration(.ReplaceMethodContentBodyChange, target: .StoreEndpointReplaceContentBody)
        let result = APITemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultStoreEndpointFacadeReplacedContentBody))
    }

    /// method `findPetsByStatus` has a new content-type of `Pet`
    func testAddedContentBodyPetEndpoint() {
        let migrationResult = migration(.AddContentBodyChange, target: .PetEndpointAddedContentBody)
        let result = APITemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeAddedContentBody))
    }
    
    func testDefaultParameterPetEndpoint() {
        let migrationResult = migration(.ReplaceDefaultValueChange, target: .PetEndpointDefaultParameter)
        let result = APITemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeDefaultParameter))
    }
    
    static var allTests = [
        ("testAddedParameter", testAddedParameter),
        ("testDeletedParameter", testDeletedParameter),
        ("testRenamedParameter", testRenamedParameter),
        ("testReplacedParameter", testReplacedParameter),
        ("testReplacedContentBodyStoreEndpoint", testReplacedContentBodyStoreEndpoint),
        ("testAddedContentBodyPetEndpoint", testAddedContentBodyPetEndpoint),
        ("testReplacedM1ParametersOfMethod", testReplacedM1ParametersOfMethod),
        ("testReplacedMNParametersOfMethod", testReplacedMNParametersOfMethod),
        ("testReplaced1NParametersOfMethod", testReplaced1NParametersOfMethod),
        ("testDefaultParameterPetEndpoint", testDefaultParameterPetEndpoint),
        ("testRequiringParameter", testRequiringParameter)
    ]
}
