// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery. File exceeds normal length due to migration guides.
// Line length exceeds due to convert/revert definition in migration guide
// swiftlint:disable identifier_name file_length type_body_length line_length
import XCTest
@testable import PallidorMigrator

class EndpointIntegrationTests: PallidorMigratorXCTestCase {
    func testRenamedEndpointAndReplaceAndDeleteMethod() {
        let current = modifiable(.PetEndpointRenamedAndReplacedAndDeletedMethod)
        let facade = modifiable(.PetEndpointFacadeReplacedMethod)
        TestCodeStore.inject(previous: [facade], current: [current])
        
        do {
            try current.accept(migrationSet(from: .RenameEndpointAndReplaceAndDeleteMethodChange))
            let result = APITemplate().render(current)
            XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamedAndReplacedAndDeletedMethod))
        } catch {
            XCTFail("Migration failed.")
        }
    }
 
    func testRenamedEndpointAndReplaceMethod() {
        let facade = modifiable(.PetEndpointFacadeReplacedMethod)
        let current = modifiable(.PetEndpointRenamedAndReplacedMethod)
        
        TestCodeStore.inject(previous: [facade], current: [current])
        
        do {
            try current.accept(migrationSet(from: .RenameEndpointAndReplaceMethodChange))
            
            let result = APITemplate().render(current)
            
            XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamedAndReplacedMethod))
        } catch {
            XCTFail("Migration failed.")
        }
    }

    func testRenamedEndpointAndDeletedMethod() {
        let facade = modifiable(.PetEndpointFacadeReplacedMethod)
        let current = modifiable(.PetEndpointRenamedAndReplacedMethod)
        
        TestCodeStore.inject(previous: [facade], current: [current])
        
        do {
            try current.accept(migrationSet(from: .RenameEndpointAndDeletedMethodChange))
            let result = APITemplate().render(current)
            
            XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamedAndDeletedMethod))
        } catch {
            XCTFail("Migration failed.")
        }
    }
    
    func testRenamedEndpointAndRenamedMethod() {
        let modified = migration(.RenameEndpointAndRenameMethodChange,
                                       target: .PetEndpointRenamedAndRenamedMethod)
        
        let result = APITemplate().render(modified)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamedAndRenamedMethod))
    }

    func testRenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterChange() {
        let modified = migration(.RenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterChange,
                                       target: .PetEndpointRenamedAndRenamedMethodAndReplacedParameter)
        let result = APITemplate().render(modified)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamedAndRenamedMethodAndReplacedParameter))
    }

    func testRenamedEndpointAndRenameMethodAndAddAndDeleteParameterChange() {
        let modified = migration(.RenamedEndpointAndRenameMethodAndAddAndDeleteParameterChange,
                                       target: .PetEndpointRenamedAndRenamedMethodAndAddedAndDeletedParameter)
        
        let result = APITemplate().render(modified)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamedMethodAndAddedAndDeletedParameter))
    }

    func testRenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterAndReplaceReturnValueChange() {
        let modified = migration(.RenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterAndReplaceReturnValueChange,
                                       target: .PetEndpointRenamedAndRenamedMethodAndReplacedAndDeletedParameterAndReplacedReturnValue)
        
        let result = APITemplate().render(modified)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamedAndRenamedMethodAndReplacedParameterAndReplacedReturnValue))
    }
    
    func testRenamedEndpointAndRenameMethodAndChangedParametersAndReplaceReturnValueChange() {
        let modified = migration(.RenamedEndpointAndRenameMethodAndChangedParametersAndReplaceReturnValueChange,
                                       target: .PetEndpointRenamedAndRenamedMethodAndChangedParametersAndReplacedReturnValue)
        
        let result = APITemplate().render(modified)
        
        XCTMigratorAssertEqual(result, .results(.ResultPetEndpointFacadeRenamedAndRenamedMethodAndChangedParametersAndReplacedReturnValue))
    }
    
    static var allTests = [
        ("testRenamedEndpointAndReplaceMethod", testRenamedEndpointAndReplaceMethod),
        ("testRenamedEndpointAndDeletedMethod", testRenamedEndpointAndDeletedMethod),
        ("testRenamedEndpointAndRenamedMethod", testRenamedEndpointAndRenamedMethod),
        ("testRenamedEndpointAndReplaceAndDeleteMethod", testRenamedEndpointAndReplaceAndDeleteMethod),
        ("testRenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterChange", testRenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterChange),
        ("testRenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterAndReplaceReturnValueChange", testRenamedEndpointAndRenameMethodAndReplaceAndDeleteParameterAndReplaceReturnValueChange),
        ("testRenamedEndpointAndRenameMethodAndAddAndDeleteParameterChange", testRenamedEndpointAndRenameMethodAndAddAndDeleteParameterChange),
        ("testRenamedEndpointAndRenameMethodAndChangedParametersAndReplaceReturnValueChange", testRenamedEndpointAndRenameMethodAndChangedParametersAndReplaceReturnValueChange)
    ]
}
