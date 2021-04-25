// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery. 
// Line length exceeds due to convert/revert definition in migration guide
// swiftlint:disable identifier_name line_length
import XCTest
@testable import PallidorMigrator

class ModelIntegrationTests: PallidorMigratorXCTestCase {
    func testDeletedAndAddedProperty() {
        let migrationResult = migration(.DeletedAndAddedProperty, target: .ModelPet)
        let result = ModelTemplate().render(migrationResult)
        
        XCTMigratorAssertEqual(result, .results(.ResultModelPetAddedAndDeletedProperty))
    }
    
    func testRenamedModelAndAddProperty() {
        let migrationResult = migration(.RenameModelAndAddPropertyChange, target: .ModelPetRenamedAndAddedProperty)
        
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelPetRenamedAndAddedProperty))
    }
    
     func testRenamedModelAndReplacedProperty() {
        let migrationResult = migration(.RenameModelAndReplacePropertyChange, target: .ModelCustomerRenamedAndReplacedProperty)
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelCustomerRenamedAndReplacedProperty))
    }
    
    func testRenamedModelAndDeletedProperty() {
        let migrationResult = migration(.RenameModelAndDeletePropertyChange, target: .ModelCustomerRenamedAndDeletedProperty)
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelCustomerRenamedAndDeletedProperty))
    }

    func testRenamedModelAndRenamedProperty() {
        let migrationResult = migration(.RenameModelAndRenamedPropertyChange, target: .ModelCategoryRenamedAndPropertyRenamed)
        
        let result = ModelTemplate().render(migrationResult)

        XCTMigratorAssertEqual(result, .results(.ResultModelCategoryRenamedAndRenamedProperty))
    }
    
    
    static var allTests = [
        ("testRenamedModelAndDeletedProperty", testRenamedModelAndDeletedProperty),
        ("testRenamedModelAndReplacedProperty", testRenamedModelAndReplacedProperty),
        ("testDeletedAndAddedProperty", testDeletedAndAddedProperty),
        ("testRenamedModelAndRenamedProperty", testRenamedModelAndRenamedProperty)
    ]
}
