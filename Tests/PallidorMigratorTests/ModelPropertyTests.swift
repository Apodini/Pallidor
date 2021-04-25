// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// Force try is disabled for lines that refer to fetching and parsing
// source code with Sourcery. 
// Line length exceeds due to convert/revert definition in migration guide
// swiftlint:disable identifier_name line_length
import XCTest
@testable import PallidorMigrator

class ModelPropertyTests: PallidorMigratorXCTestCase {
    /// simulates that `city` property was added after initial facade generation
    func testAddedProperty() {
        let migrationResult = migration(.AddSinglePrimitivePropertyChange, target: .ModelAddress)
        let result = ModelTemplate().render(migrationResult)
        
        XCTAssertEqual(result, expectation(.ResultModelAddressAddedSimpleProperty))
    }
    
    /// simulates that `category` property was added after initial facade generation
    func testAddedComplexProperty() {
        let migrationResult = migration(.AddSingleComplexPropertyChange, target: .ModelPet)
        
        let result = ModelTemplate().render(migrationResult)
        
        XCTAssertEqual(result, expectation(.ResultModelPetAddedComplexProperty))
    }
    
    /// simulates a removed property `weight : String` from `Pet`
    /// - provides a fallback-value
    func testDeletedProperty() {
        let migrationResult = migration(.DeletePropertyChange, target: .ModelPet)
        let result = ModelTemplate().render(migrationResult)
        
        XCTAssertEqual(result, expectation(.ResultModelPetDeletedProperty))
    }
    
    func testReplacedProperty() {
        let migrationResult = migration(.ReplacePropertyTypeChange, target: .ModelCustomerReplacedProperty)
        let result = ModelTemplate().render(migrationResult)
        
        XCTAssertEqual(result, expectation(.ResultModelCustomerReplacedProperty))
    }

    /// renames two properties from different models (`Pet` & `Category`)
    func testRenamedProperty() {
        let migrationResultPet = migration(.RenamePropertyChange, target: .ModelPetRenamedProperty)
        let resultPet = ModelTemplate().render(migrationResultPet)
        
        XCTAssertEqual(resultPet, expectation(.ResultModelPetRenamedProperty))
        
        let migrationResultCategory = migration(.RenamePropertyChange, target: .ModelCategoryRenamedProperty)
        let resultCategory = ModelTemplate().render(migrationResultCategory)
        
        XCTAssertEqual(resultCategory, expectation(.ResultModelCategoryRenamedProperty))
    }
    
    
    static var allTests = [
        ("testAddedProperty", testAddedProperty),
        ("testAddedComplexProperty", testAddedComplexProperty),
        ("testDeletedProperty", testDeletedProperty),
        ("testReplacedProperty", testReplacedProperty),
        ("testRenamedProperty", testRenamedProperty)
    ]
}
