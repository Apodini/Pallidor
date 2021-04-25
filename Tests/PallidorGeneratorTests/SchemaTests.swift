import XCTest
import OpenAPIKit
@testable import PallidorGenerator

class SchemaTests: XCTestCase {
    var sut: SchemaConverter?
    
    func testParseDefaultSchema() {
        initSUT(resource: .petstore)
        if let test = sut?.getSchema(name: "Pet") {
            XCTGeneratorAssertEqual(test.description, .results(.Pet))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseComplexSchema() {
        initSUT(resource: .lufthansa)
        if let test = sut?.getSchema(name: "FlightAggregate") {
            XCTGeneratorAssertEqual(test.description, .results(.FlightAggregate))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseDefaultEnum() {
        initSUT(resource: .lufthansa)
        if let test = sut?.getSchema(name: "MessageLevel") {
            XCTGeneratorAssertEqual(test.description, .results(.MessageLevel))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseResolvedTypeAliasSchema() {
        initSUT(resource: .lufthansa)
        if let test = sut?.getSchema(name: "PeriodOfOperation") {
            XCTGeneratorAssertEqual(test.description, .results(.PeriodOfOperation))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseOneOfSchema() {
        initSUT(resource: .wines)
        if let test = sut?.getSchema(name: "PaymentInstallmentSchedule") {
            XCTGeneratorAssertEqual(test.description, .results(.PaymentInstallmentSchedule))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseAnyOfSchema() {
        initSUT(resource: .wines_any)
        if let test = sut?.getSchema(name: "PaymentInstallmentSchedule") {
            XCTGeneratorAssertEqual(test.description, .results(.PaymentInstallmentSchedule_Any))
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
        
        sut?.parse()
    }
    
    override func tearDown() {
        TypeAliases.store.removeAll()
        OpenAPIErrorModel.errorTypes.removeAll()
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
