import XCTest
import PathKit
import OpenAPIKit
@testable import PallidorGenerator

final class PallidorGeneratorTests: XCTestCase {
    var sut: MetaModelConverter?
    
    func testGenerateErrorModel() {
        initSUT(resource: .lufthansa)
        if let errorType = OpenAPIErrorModel.errorTypes.first {
            XCTAssertEqual(errorType, "_ErrorResponse")
        } else {
            XCTFail("No error type found")
        }
    }
    
    private func initSUT(resource: Resources) {
        guard let apiSpec = readResource(resource) else {
            fatalError("Specification could not be retrieved.")
        }
        TypeAliases.parse(resolvedDoc: apiSpec)
        var schemas = SchemaConverter(apiSpec)
        schemas.parse()
        var apis = APIConverter(apiSpec)
        apis.parse()
        sut = MetaModelConverter()
    }
    
    static var allTests = [
        ("testGenerateErrorModel", testGenerateErrorModel)
    ]
}
