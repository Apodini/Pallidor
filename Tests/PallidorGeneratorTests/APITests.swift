import XCTest
import OpenAPIKit
@testable import PallidorGenerator

class APITests: XCTestCase {
    var sut: APIConverter?
    
    func testParseTypeAliasResultMethod() {
        initSUT(resource: .lufthansa)
        // Is initialized by `initSUT` statement
        // swiftlint:disable:next force_unwrapping
        if let test = sut!.getOperation("getPassengerFlights", in: "Flightschedules") {
            XCTAssertEqual(test.description, readResult(.LH_GetPassengerFlights))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseDefaultResultMethod() {
        initSUT(resource: .petstore)
        // Is initialized by `initSUT` statement
        // swiftlint:disable:next force_unwrapping
        if let test = sut!.getOperation("addPet", in: "Pet") {
            XCTAssertEqual(test.description, readResult(.Pet_addPet))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseDefaultResultMethodNoAuth() {
        initSUT(resource: .petstore_httpMethodChanged)
        // Is initialized by `initSUT` statement
        // swiftlint:disable:next force_unwrapping
        if let test = sut!.getOperation("addPet", in: "Pet") {
            // modify "authorization" parameter to be optional.
            // uses authorized result of "addPet" method
            var result = readResult(.Pet_addPet)
            result = result.replacingOccurrences(
                of: "authorization: HTTPAuthorization = NetworkManager.authorization!",
                with: "authorization: HTTPAuthorization? = NetworkManager.authorization"
            )
            XCTAssertEqual(test.description, result)
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseSimpleResultMethod() {
        initSUT(resource: .petstore)
        // Is initialized by `initSUT` statement
        // swiftlint:disable:next force_unwrapping
        if let test = sut!.getOperation("updatePetWithForm", in: "Pet") {
            XCTAssertEqual(test.description, readResult(.Pet_updatePetWithForm))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseSimpleEndpointMethod() {
        initSUT(resource: .petstore)
        // Is initialized by `initSUT` statement
        // swiftlint:disable:next force_unwrapping
        if let test = sut!.getEndpoint("Pet") {
            XCTAssertEqual(test.description, readResult(.Pet_Endpoint))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseSimpleEndpointMethodChangedHTTPMethod() {
        initSUT(resource: .petstore_httpMethodChanged)
        // Is initialized by `initSUT` statement
        // swiftlint:disable:next force_unwrapping
        if let test = sut!.getOperation("updatePet", in: "Pet") {
            XCTAssertEqual(test.description, readResult(.Pet_updatePetChangedHTTPMethod))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseSimpleEndpointMinMaxMethod() {
        initSUT(resource: .petstore_minMax)
        // Is initialized by `initSUT` statement
        // swiftlint:disable:next force_unwrapping
        if let test = sut!.getOperation("getPetById", in: "Pet") {
            XCTAssertEqual(test.description, readResult(.Pet_getPetByIdMinMax))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseOAIErrorEnum() {
        initSUT(resource: .petstore_unmodified)
        XCTAssertEqual(OpenAPIErrorModel().description, readResult(.OpenAPIErrorModel))
    }
    
    private func initSUT(resource: Resources) {
        guard let apiSpec = readResource(resource) else {
            fatalError("Specification could not be retrieved.")
        }
        TypeAliases.parse(resolvedDoc: apiSpec)
        sut = APIConverter(apiSpec)
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
        ("testParseTypeAliasResultMethod", testParseTypeAliasResultMethod),
        ("testParseDefaultResultMethod", testParseDefaultResultMethod),
        ("testParseSimpleResultMethod", testParseSimpleResultMethod),
        ("testParseSimpleEndpointMethod", testParseSimpleEndpointMethod),
        ("testParseSimpleEndpointMethodChangedHTTPMethod", testParseSimpleEndpointMethodChangedHTTPMethod),
        ("testParseSimpleEndpointMinMaxMethod", testParseSimpleEndpointMinMaxMethod)
    ]
}
