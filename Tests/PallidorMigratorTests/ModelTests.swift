// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery.
// Line length exceeds due to convert/revert definition in migration guide
// swiftlint:disable identifier_name line_length
import XCTest
@testable import PallidorMigrator

class ModelTests: PallidorMigratorXCTestCase {
    func testNoChangeToPetModel() {
        let migrationResult = migration(.EmptyGuide, target: .ModelPet)
        let result = ModelTemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultModelPet))
    }
    
    func testDeletedModel() {
        let facade = modifiable(.ModelApiResponseFacadeDeleted)
        TestCodeStore.inject(previous: [facade], current: [])
        
        _ = migration(.DeleteModelChange, target: .ModelPlaceholder)
        
        guard let migrationResult = TestCodeStore.instance.model(facade.id, scope: .currentAPI) else {
            fatalError("Could not retrieve migrated modifiable.")
        }

        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelApiResponseDeleted))
    }
 
    func testReplacedModel() {
        let migrationResult = migration(.ReplaceModelChange, target: .ModelOrderFacadeReplaced)
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelOrderReplaced))
    }

    func testRenamedModel() {
        let migrationResult = migration(.RenameModelChange, target: .ModelAddressRenamed)
        
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelAddressRenamed))
    }
        
    
    static var allTests = [
        ("testDeletedModel", testDeletedModel),
        ("testRenamedModel", testRenamedModel),
        ("testReplacedModel", testReplacedModel),
        ("testNoChangeToPetModel", testNoChangeToPetModel)
    ]
}
