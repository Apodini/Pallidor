// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery. 
// Line length exceeds due to convert/revert definition in migration guide
// swiftlint:disable identifier_name line_length
import XCTest
@testable import PallidorMigrator

class MethodTests: PallidorMigratorXCTestCase {
    let renameMethodChange = """
   {
       "summary" : "Here would be a nice summary what changed between versions",
       "api-spec": "OpenAPI",
       "api-type": "REST",
       "from-version" : "0.0.1b",
       "to-version" : "0.0.2",
       "changes" : [
           {
               "reason": "Security issue related change",
               "object" : {
                   "operation-id" : "addMyPet",
                   "defined-in" : "/pet"
               },
               "target" : "Signature",
               "original-id" : "addPet"
           }
       ]

   }
   """
    
    /// method `addPet()` is renamed to `addMyPet()`
    /// parameters & return value remain the same
    func testRenamedMethod() {
        let migrationResult = migration(.RenameMethodChange, target: .PetEndpointRenamedMethod)
        let result = APITemplate().render(migrationResult)
        
        XCTAssertEqual(result, expectation(.ResultPetEndpointFacadeRenamedMethod))
    }
    
    let deleteMethodChange = """
   {
       "summary" : "Here would be a nice summary what changed between versions",
       "api-spec": "OpenAPI",
       "api-type": "REST",
       "from-version" : "0.0.1b",
       "to-version" : "0.0.2",
       "changes" : [
           {
               "object" : {
                   "operation-id" : "addPet",
                   "defined-in" : "/pet"
               },
               "target" : "Signature",
               "fallback-value" : { }
           }
       ]
   }
   """
    
    
    func testDeletedMethod() throws {
        let facade = modifiable(.PetEndpointFacade)
        let current = modifiable(.PetEndpointDeletedMethod)
        TestCodeStore.inject(previous: [facade], current: [current])
        
        let guide = migrationGuide(.DeleteMethodChange)
        let migrationGuide = try MigrationGuide.guide(with: guide).handled(in: TestCodeStore.instance)
        current.accept(change: migrationGuide.changes[0])
      
        let result = APITemplate().render(current)

        XCTAssertEqual(result, expectation(.ResultPetEndpointFacadeDeletedMethod))
    }
    
    /// method `updatePet()` is replaced by `updateMyPet()` in `User` endpoint
    /// method `updateMyPet()` was put `User` from `Pet` endpoint
    /// parameters & return value are also changed
    func testReplacedMethod() {
        let facade = modifiable(.PetEndpointFacadeReplacedMethod)
        let current = modifiable(.PetEndpointReplacedMethod)
        let current2 = modifiable(.UserEndpointReplacedMethod)
        TestCodeStore.inject(previous: [facade], current: [current, current2])
        
        guard let modAPI = TestCodeStore.instance.endpoint("/pet", scope: .currentAPI) else {
            fatalError("Could not retrieve endpoint.")
        }
        
        _ = migration(.ReplaceMethodChange, target: .UserEndpointReplacedMethod)
        
        let result = APITemplate().render(modAPI)
        
        XCTAssertEqual(result, expectation(.ResultPetEndpointFacadeReplacedMethod))
    }
        
    /// method `updatePet()` is replaced by `updatePetWithForm()` in `Pet` endpoint (same)
    /// parameters & return value are also changed
    func testReplacedMethodInSameEndpoint() {
        let facade = modifiable(.PetEndpointFacadeReplacedMethod)
        let current = modifiable(.PetEndpointReplacedMethod)
        TestCodeStore.inject(previous: [facade], current: [current])
        
        _ = migration(.ReplaceMethodInSameEndpointChange, target: .PetEndpointReplacedMethod)
        guard let endpoint = TestCodeStore.instance.endpoint("/pet", scope: .currentAPI) else {
            fatalError("Could not retrieve endpoint.")
        }
        
        let result = APITemplate().render(endpoint)
        
        XCTAssertEqual(result, expectation(.ResultPetEndpointFacadeReplacedMethodInSameEndpoint))
    }

    func testReplacedReturnValue() {
        let migrationResult = migration(.ReplaceMethodReturnTypeChange, target: .PetEndpointReplacedReturnValue)
        
        let result = APITemplate().render(migrationResult)
        
        XCTAssertEqual(result, expectation(.ResultPetEndpointFacadeReplacedReturnValue))
    }
    
    
    static var allTests = [
        ("testDeletedMethod", testDeletedMethod),
        ("testRenamedMethod", testRenamedMethod),
        ("testReplacedMethod", testReplacedMethod),
        ("testReplacedReturnValue", testReplacedReturnValue),
        ("testReplacedMethodInSameEndpoint", testReplacedMethodInSameEndpoint)
    ]
}
