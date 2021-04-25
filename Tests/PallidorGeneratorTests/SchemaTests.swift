import XCTest
import OpenAPIKit
@testable import PallidorGenerator

class SchemaTests: XCTestCase {
    var sut: SchemaConverter?
    
    func testParseDefaultSchema() {
        initSUT(resource: .petstore)
        if let test = sut?.getSchema(name: "Pet") {
            XCTAssertEqual(test.description, readResult(.Pet))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseComplexSchema() {
        initSUT(resource: .lufthansa)
        if let test = sut?.getSchema(name: "FlightAggregate") {
            XCTAssertEqual(test.description, readResult(.FlightAggregate))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseDefaultEnum() {
        initSUT(resource: .lufthansa)
        if let test = sut?.getSchema(name: "MessageLevel") {
            XCTAssertEqual(test.description, readResult(.MessageLevel))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseResolvedTypeAliasSchema() {
        initSUT(resource: .lufthansa)
        if let test = sut?.getSchema(name: "PeriodOfOperation") {
            XCTAssertEqual(test.description, readResult(.PeriodOfOperation))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseOneOfSchema() {
        initSUT(resource: .wines)
        if let test = sut?.getSchema(name: "PaymentInstallmentSchedule") {
            XCTAssertEqual(test.description, readResult(.PaymentInstallmentSchedule))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseAnyOfSchema() {
        initSUT(resource: .wines_any)
        if let test = sut?.getSchema(name: "PaymentInstallmentSchedule") {
            XCTAssertEqual(test.description, readResult(.PaymentInstallmentSchedule_Any))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    private func initSUT(resource: Resources) {
        guard let apiSpec = readResource(resource) else {
            fatalError("Specification could not be retrieved.")
        }
        TypeAliases.parse(resolvedDoc: apiSpec)
        sut = SchemaConverter(apiSpec)
        // Is initialized in previous statement
        // swiftlint:disable:next force_unwrapping
        sut!.parse()
    }
    
    override func tearDown() {
        TypeAliases.store = [String: String]()
        OpenAPIErrorModel.errorTypes = Set<String>()
        super.tearDown()
    }
    
    static var allTests = [
        ("testParseDefaultSchema", testParseDefaultSchema),
        ("testParseDefaultEnum", testParseDefaultEnum),
        ("testParseComplexSchema", testParseComplexSchema),
        ("testParseResolvedTypeAliasSchema", testParseResolvedTypeAliasSchema),
        ("testParseOneOfSchema", testParseOneOfSchema),
        ("testParseAnyOfSchema", testParseAnyOfSchema)
    ]
}
