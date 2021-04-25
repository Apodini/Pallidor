// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// swiftlint:disable identifier_name
import Foundation
import XCTest
import OpenAPIKit
import PallidorUtils

extension XCTestCase: ResourceHandler {
    public typealias Container = InnerContainer
    
    public enum InnerContainer: ResourceContainer {
        case resources(Resources)
        case results(Results)
        
        public var instance: Resource {
            switch self {
            case let .resources(instance):
                return instance
            case let .results(instance):
                return instance
            }
        }
    }
    
    public enum Resources: String, Resource {
        case petstore, petstore_httpMethodChanged,
             petstore_minMax, lufthansa, wines, wines_any,
             petstore_unmodified
        
        public var bundle: Bundle { .module }
        public var name: String { rawValue }
    }
    
    public enum Results: String, Resource {
        case Pet, MessageLevel, PaymentInstallmentSchedule,
             PaymentInstallmentSchedule_Any, PeriodOfOperation,
             FlightAggregate, LH_GetPassengerFlights, Pet_addPet,
             Pet_updatePetWithForm, Pet_Endpoint, Pet_updatePetChangedHTTPMethod,
             Pet_getPetByIdMinMax, OpenAPIErrorModel
        
        public var bundle: Bundle { .module }
        public var name: String { rawValue }
    }
    
    func readResult(_ resource: Results) -> String {
        do {
            return try resource.content()
        } catch {
            XCTFail("Could not read the resource")
            print(error)
        }
        
        return ""
    }
    
    func readResource(_ resource: Resources) -> ResolvedDocument? {
        do {
            let document = try JSONDecoder().decode(OpenAPI.Document.self, from: try resource.data())
            return try document.locallyDereferenced().resolved()
        } catch {
            XCTFail("Could not read the resource")
            print(error)
        }
        
        return nil
    }
    
    /// AssertEqual used throughout the target
    func XCTGeneratorAssertEqual(_ expression: String, _ container: Container, overrideResource: Bool = false) {
        let instance = container.instance
        do {
            let instanceContent = try instance.content()
            
            if expression != instanceContent, overrideResource {
                write(content: expression, for: container)
            }
            
            XCTAssertEqual(expression, instanceContent)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
