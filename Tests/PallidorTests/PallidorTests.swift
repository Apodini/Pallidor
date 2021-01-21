import XCTest
import Foundation
@testable import Pallidor
import PallidorGenerator
import PallidorMigrator


final class PallidorTests: XCTestCase {
    func testGenerator() throws {
        let specification = try readResource("openapi")
        let generator = try PallidorGenerator(specification: specification)
        XCTAssertNotNil(generator)
    }
    
    func testMigrator() throws {
        let migrationguide = try readResource("migrationguide")
        let migrator = try PallidorMigrator(targetDirectory: "", migrationGuideContent: migrationguide)
        XCTAssertNotNil(migrator)
    }

    fileprivate func readResource(_ resource: String) throws -> String {
        let fileURL = try XCTUnwrap(Bundle.module.url(forResource: resource, withExtension: "md"))
        return String((try String(contentsOf: fileURL, encoding: .utf8)).dropLast())
    }
}
