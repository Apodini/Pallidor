import XCTest
import Foundation
@testable import Pallidor
import PallidorGenerator
import PallidorMigrator

final class PallidorTests: XCTestCase {
    func testGenerator() throws {
        let specification = readResource("openapi")
        let generator = try PallidorGenerator(specification: specification)
        XCTAssertNotNil(generator)
    }
    
    func testMigrator() throws {
        let migrationguide = readResource("migrationguide")
        let migrator = try PallidorMigrator(targetDirectory: "", migrationGuideContent: migrationguide)
        XCTAssertNotNil(migrator)
    }

    fileprivate func readResource(_ resource: String) -> String {
        guard let fileURL = Bundle.module.url(forResource: resource, withExtension: "md") else {
            XCTFail("Could not locate the resource")
            return ""
        }
        
        do {
            return String((try String(contentsOf: fileURL, encoding: .utf8)).dropLast())
        } catch {
            XCTFail("Could not read the resource")
        }
        
        return ""
    }
    
    static var allTests = [
        ("testGenerator", testGenerator)
    ]
}
