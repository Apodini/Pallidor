// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery.
// Line length exceeds due to convert/revert definition in migration guide
// swiftlint:disable identifier_name line_length
import XCTest
@testable import PallidorMigrator

class ModelTests: XCTestCase {
    func testNoChangeToPetModel() {
        let migrationResult = getMigrationResult(migration: noChange, target: readResource(Resources.ModelPet.rawValue))
        let result = ModelTemplate().render(migrationResult)
        
        XCTAssertEqual(result, readResource(Resources.ResultModelPet.rawValue))
    }
    
    let deleteModelChange = """
   {
       "summary" : "Here would be a nice summary what changed between versions",
       "api-spec": "OpenAPI",
       "api-type": "REST",
       "from-version" : "0.0.1b",
       "to-version" : "0.0.2",
       "changes" : [
           {
               "object" : {
                   "name" : "ApiResponse"
               },
               "target" : "Signature",
               "fallback-value" : { }
           }
       ]
   }
   """
    
    func testDeletedModel() {
        let facade = modifiableFile(from: readResource(Resources.ModelApiResponseFacadeDeleted.rawValue))
        
        TestCodeStore.inject(previous: [facade], current: [])
        
        _ = getMigrationResult(
            migration: deleteModelChange,
            target: readResource(Resources.ModelPlaceholder.rawValue)
        )
        
        guard let migrationResult = TestCodeStore.instance.model(facade.id, scope: .currentAPI) else {
            fatalError("Could not retrieve migrated modifiable.")
        }

        let result = ModelTemplate().render(migrationResult)

        XCTAssertEqual(result, readResource(Resources.ResultModelApiResponseDeleted.rawValue))
    }
    
    let replaceModelChange = """
   {
       "summary" : "Here would be a nice summary what changed between versions",
       "api-spec": "OpenAPI",
       "api-type": "REST",
       "from-version" : "0.0.1b",
       "to-version" : "0.0.2",
       "changes" : [
           {
               "object" : {
                   "name" : "Order"
               },
               "target" : "Signature",
               "replacement-id" : "NewOrder",
               "custom-convert" : "function conversion(o) { return JSON.stringify({ 'id' : o.id, 'petId' : o.petId, 'quantity': o.quantity  }) }",
               "custom-revert" : "function conversion(o) { return JSON.stringify({ 'id' : o.id, 'petId' : o.petId, 'quantity': o.quantity, 'complete' : 'false', 'status' : 'available' }) }",
           }
       ]

   }
   """
    
    func testReplacedModel() {
        let migrationResult = getMigrationResult(
            migration: replaceModelChange,
            target: readResource(Resources.ModelOrderFacadeReplaced.rawValue)
        )

        let result = ModelTemplate().render(migrationResult)

        XCTAssertEqual(result, readResource(Resources.ResultModelOrderReplaced.rawValue))
    }
    
    
    let renameModelChange = """
   {
       "summary" : "Here would be a nice summary what changed between versions",
       "api-spec": "OpenAPI",
       "api-type": "REST",
       "from-version" : "0.0.1b",
       "to-version" : "0.0.2",
       "changes" : [
           {
               "object" : {
                   "name" : "NewAddress"
               },
               "target" : "Signature",
               "original-id" : "Address"
           },
           {
               "object" : {
                   "name" : "Customer"
               },
               "target" : "Property",
               "replacement-id" : "address",
                "type" : "NewAddress",
              "custom-convert" : "function conversion(o) { return o }",
              "custom-revert" : "function conversion(o) { return o }",
               "replaced" : {
                   "name" : "address",
                   "type" : "[Address]"
               }
           }
       ]
   }
   """

    func testRenamedModel() {
        let migrationResult = getMigrationResult(
            migration: renameModelChange,
            target: readResource(Resources.ModelAddressRenamed.rawValue)
        )
        let result = ModelTemplate().render(migrationResult)

        XCTAssertEqual(result, readResource(Resources.ResultModelAddressRenamed.rawValue))
    }
        
    enum Resources: String {
        case ModelPet, ModelApiResponseFacadeDeleted, ModelPlaceholder, ModelOrderFacadeReplaced, ModelAddressRenamed, ModelCustomerRenamedAndReplacedProperty
        case ResultModelPet, ResultModelApiResponseDeleted, ResultModelOrderReplaced, ResultModelAddressRenamed
    }
    
    static var allTests = [
        ("testDeletedModel", testDeletedModel),
        ("testRenamedModel", testRenamedModel),
        ("testReplacedModel", testReplacedModel),
        ("testNoChangeToPetModel", testNoChangeToPetModel)
    ]
}
