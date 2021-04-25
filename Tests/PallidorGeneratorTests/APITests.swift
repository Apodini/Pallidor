import XCTest
import OpenAPIKit
@testable import PallidorGenerator

class APITests: XCTestCase {
    var sut: APIConverter?
    
    func testParseTypeAliasResultMethod() {
        initSUT(resource: .lufthansa)
        if let test = sut?.getOperation("getPassengerFlights", in: "Flightschedules") {
            XCTResourceHandlerAssertEqual(test.description, .results(.LH_GetPassengerFlights))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseDefaultResultMethod() {
        initSUT(resource: .petstore)
        if let test = sut?.getOperation("addPet", in: "Pet") {
            XCTResourceHandlerAssertEqual(test.description, .results(.Pet_addPet))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseDefaultResultMethodNoAuth() {
        initSUT(resource: .petstore_httpMethodChanged)
        if let test = sut?.getOperation("addPet", in: "Pet") {
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
        if let test = sut?.getOperation("updatePetWithForm", in: "Pet") {
            XCTResourceHandlerAssertEqual(test.description, .results(.Pet_updatePetWithForm))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseSimpleEndpointMethod() {
        initSUT(resource: .petstore)
        if let test = sut?.getEndpoint("Pet") {
            XCTResourceHandlerAssertEqual(test.description, .results(.Pet_Endpoint))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseSimpleEndpointMethodChangedHTTPMethod() {
        initSUT(resource: .petstore_httpMethodChanged)
        if let test = sut?.getOperation("updatePet", in: "Pet") {
            XCTResourceHandlerAssertEqual(test.description, .results(.Pet_updatePetChangedHTTPMethod))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseSimpleEndpointMinMaxMethod() {
        initSUT(resource: .petstore_minMax)
        if let test = sut?.getOperation("getPetById", in: "Pet") {
            XCTResourceHandlerAssertEqual(test.description, .results(.Pet_getPetByIdMinMax))
        } else {
            XCTFail("Library could not be generated.")
        }
    }
    
    func testParseOAIErrorEnum() {
        initSUT(resource: .petstore_unmodified)
        XCTResourceHandlerAssertEqual(OpenAPIErrorModel().description, .results(.OpenAPIErrorModel))
    }
    
    private func initSUT(resource: Resources) {
        guard let apiSpec = readResource(resource) else {
            fatalError("Specification could not be retrieved.")
        }
        TypeAliases.parse(resolvedDoc: apiSpec)
        sut = APIConverter(apiSpec)
        sut?.parse()
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
