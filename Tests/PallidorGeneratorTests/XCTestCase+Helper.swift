// Identifier_name linting rule is disabled
// because enum cases reflect the names of corresponding test files
// swiftlint:disable identifier_name
import Foundation
import XCTest
import OpenAPIKit

extension XCTestCase {
    enum Resources: String {
        case petstore, petstore_httpMethodChanged,
             petstore_minMax, lufthansa, wines, wines_any,
             petstore_unmodified
    }
    
    enum Results: String {
        case Pet, MessageLevel, PaymentInstallmentSchedule,
             PaymentInstallmentSchedule_Any, PeriodOfOperation,
             FlightAggregate, LH_GetPassengerFlights, Pet_addPet,
             Pet_updatePetWithForm, Pet_Endpoint, Pet_updatePetChangedHTTPMethod,
             Pet_getPetByIdMinMax, OpenAPIErrorModel
    }
    
    func readResult(_ resource: Results) -> String {
        guard let fileURL = Bundle.module.url(forResource: resource.rawValue, withExtension: "md") else {
            XCTFail("Could not locate the resource")
            return ""
        }
        
        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            XCTFail("Could not read the resource")
            print(error)
        }
        
        return ""
    }
    
    func readResource(_ resource: Resources) -> ResolvedDocument? {
        guard let fileURL = Bundle.module.url(forResource: resource.rawValue, withExtension: "md") else {
            XCTFail("Could not locate the resource")
            return nil
        }
        
        do {
            let document = try JSONDecoder().decode(OpenAPI.Document.self, from: Data(contentsOf: fileURL))
            return try document.locallyDereferenced().resolved()
        } catch {
            XCTFail("Could not read the resource")
            print(error)
        }
        
        return nil
    }
}
