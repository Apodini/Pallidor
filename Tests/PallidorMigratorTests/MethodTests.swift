// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery. 
// Line length exceeds due to convert/revert definition in migration guide
// swiftlint:disable identifier_name line_length
import XCTest
@testable import PallidorMigrator

class MethodTests: XCTestCase {
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
        let migrationResult = getMigrationResult(
            migration: renameMethodChange,
            target: readResource(Resources.PetEndpointRenamedMethod.rawValue)
        )
        let result = APITemplate().render(migrationResult)
        
        XCTAssertEqual(result, readResource(Resources.ResultPetEndpointFacadeRenamedMethod.rawValue))
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
    
    func resource(_ resource: Resources) -> ModifiableFile {
        modifiableFile(from: readResource(resource.rawValue))
    }
    
    func testDeletedMethod() throws {
        let facade = resource(.PetEndpointFacade)
        let current = resource(.PetEndpointDeletedMethod)
        TestCodeStore.inject(previous: [facade], current: [current])
        
        let migrationGuide = try MigrationGuide.guide(with: deleteMethodChange).handled(in: TestCodeStore.instance)
        current.accept(change: migrationGuide.changes[0])
      
        let result = APITemplate().render(current)

        XCTAssertEqual(result, readResource(Resources.ResultPetEndpointFacadeDeletedMethod.rawValue))
    }
    
    let replaceMethodChange = """
   {
       "summary" : "Here would be a nice summary what changed between versions",
       "api-spec": "OpenAPI",
       "api-type": "REST",
       "from-version" : "0.0.1b",
       "to-version" : "0.0.2",
       "changes" : [
           {
               "object":{
                  "operation-id":"updateMyPet",
                  "defined-in":"/user"
               },
               "target" : "Signature",
               "replacement-id" : "updateMyPet",
               "custom-convert" : "function conversion(o) { return JSON.stringify({ 'type' : 'PSI' } )}",
               "custom-revert" : "function conversion(o) { return JSON.stringify({ 'type': '', 'of' : { 'type': 'PSI'} } )}",
               "replaced" : {
                  "operation-id":"updatePet",
                  "defined-in":"/pet"
                }
           }
       ]

   }
   """
    
    /// method `updatePet()` is replaced by `updateMyPet()` in `User` endpoint
    /// method `updateMyPet()` was put `User` from `Pet` endpoint
    /// parameters & return value are also changed
    func testReplacedMethod() {
        let facade = resource(.PetEndpointFacadeReplacedMethod)
        let current = resource(.PetEndpointReplacedMethod)
        let current2 = resource(.UserEndpointReplacedMethod)
        TestCodeStore.inject(previous: [facade], current: [current, current2])
        
        let store = TestCodeStore.instance
        
        guard let modAPI = store.endpoint("/pet", scope: .currentAPI) else {
            fatalError("Could not retrieve endpoint.")
        }
        
        _ = getMigrationResult(
            migration: replaceMethodChange,
            target: readResource(Resources.UserEndpointReplacedMethod.rawValue)
        )
        let result = APITemplate().render(modAPI)
        
        XCTAssertEqual(result, readResource(Resources.ResultPetEndpointFacadeReplacedMethod.rawValue))
    }
    
    let replaceMethodInSameEndpointChange = """
   {
       "summary" : "Here would be a nice summary what changed between versions",
       "api-spec": "OpenAPI",
       "api-type": "REST",
       "from-version" : "0.0.1b",
       "to-version" : "0.0.2",
       "changes" : [
           {
               "object":{
                  "operation-id":"updatePetWithForm",
                  "defined-in":"/pet"
               },
               "target" : "Signature",
               "replacement-id" : "updatePetWithForm",
               "custom-convert" : "function conversion(o) { return JSON.stringify({ 'type' : 'PSI' } )}",
               "custom-revert" : "function conversion(o) { return JSON.stringify({ 'type': '', 'of' : { 'type': 'PSI'} } )}",
               "replaced" : {
                  "operation-id":"updatePet",
                  "defined-in":"/pet"
                }
           }
       ]

   }
   """
    
    /// method `updatePet()` is replaced by `updatePetWithForm()` in `Pet` endpoint (same)
    /// parameters & return value are also changed
    func testReplacedMethodInSameEndpoint() {
        let facade = resource(.PetEndpointFacadeReplacedMethod)
        let current = resource(.PetEndpointReplacedMethod)
        TestCodeStore.inject(previous: [facade], current: [current])
        
        _ = getMigrationResult(
            migration: replaceMethodInSameEndpointChange,
            target: readResource(Resources.PetEndpointReplacedMethod.rawValue)
        )
        
        guard let endpoint = TestCodeStore.instance.endpoint("/pet", scope: .currentAPI) else {
            fatalError("Could not retrieve endpoint.")
        }
        
        let result = APITemplate().render(endpoint)
        
        XCTAssertEqual(result, readResource(Resources
                                                .ResultPetEndpointFacadeReplacedMethodInSameEndpoint
                                                .rawValue))
    }
    
    let replaceMethodReturnTypeChange = """
      {
         "lang":"Swift",
         "summary":"Here would be a nice summary what changed between versions",
         "api-spec":"OpenAPI",
         "api-type":"REST",
         "from-version":"0.0.1b",
         "to-version":"0.0.2",
         "changes":[
            {
               "object":{
                  "operation-id":"updatePet",
                  "defined-in":"/pet"
               },
               "target":"ReturnValue",
               "replacement-id":"_",
               "type":"ApiResponse",
               "custom-revert":"function conversion(response) { var response = JSON.parse(response) return JSON.stringify({ 'id' : response.code, 'name' : response.message, 'photoUrls': [response.type], 'status' : 'available', 'tags': [ { 'id': 27, 'name': 'tag2' } ] }) }",
               "replaced":{
                  "name":"_",
                  "type":"Pet"
               }
            },
            {
               "object":{
                  "operation-id":"findPetsByStatus",
                  "defined-in":"/pet"
               },
               "target":"ReturnValue",
               "replacement-id":"_",
               "type":"[ApiResponse]",
               "custom-revert":"function conversion(response) { var response = JSON.parse(response) return JSON.stringify({ 'id' : response.code, 'name' : response.message, 'photoUrls': [response.type], 'status' : 'available', 'tags': [ { 'id': 27, 'name': 'tag2' } ] }) }",
               "replaced":{
                  "name":"_",
                  "type":"[Pet]"
               }
            },
            {
               "object":{
                  "operation-id":"addPet",
                  "defined-in":"/pet"
               },
               "target":"ReturnValue",
               "replacement-id":"_",
               "type":"Int32",
               "custom-revert": "function conversion(o) { return JSON.stringify({ 'type' : 'object' } )}",
               "replaced":{
                  "name":"_",
                  "type":"Pet"
               }
            }
         ]
      }

      """
    
    func testReplacedReturnValue() {
        let migrationResult = getMigrationResult(migration: replaceMethodReturnTypeChange, target: readResource(Resources.PetEndpointReplacedReturnValue.rawValue))
        let result = APITemplate().render(migrationResult)
        
        XCTAssertEqual(result, readResource(Resources.ResultPetEndpointFacadeReplacedReturnValue.rawValue))
    }
    

    enum Resources: String {
        case PetEndpointRenamedMethod, PetEndpointReplacedReturnValue, PetEndpointFacade, PetEndpointDeletedMethod, PetEndpointFacadeReplacedMethod, PetEndpointReplacedMethod, UserEndpointReplacedMethod
        case ResultPetEndpointFacadeRenamedMethod, ResultPetEndpointFacadeReplacedReturnValue, ResultPetEndpointFacadeDeletedMethod, ResultPetEndpointFacadeReplacedMethod, ResultPetEndpointFacadeReplacedMethodInSameEndpoint
    }
    
    static var allTests = [
        ("testDeletedMethod", testDeletedMethod),
        ("testRenamedMethod", testRenamedMethod),
        ("testReplacedMethod", testReplacedMethod),
        ("testReplacedReturnValue", testReplacedReturnValue),
        ("testReplacedMethodInSameEndpoint", testReplacedMethodInSameEndpoint)
    ]
}
