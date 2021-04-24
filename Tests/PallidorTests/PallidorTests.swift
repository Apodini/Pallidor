import XCTest
import Foundation
import PallidorGenerator
import PallidorMigrator
import PathKit


final class PallidorTests: XCTestCase {
    func testGeneratorInitialization() throws {
        XCTAssertNoThrow(try PallidorGenerator(specification: try readResource("openapi")))
    }
    
    func testMigratorInitialization() throws {
        // PallidorMigrator normally throws if targetDirectory does not exist, therefore #file
        XCTAssertNoThrow(try PallidorMigrator(targetDirectory: Path(#file).parent().string, migrationGuideContent: try readResource("migrationguide")))
    }

    fileprivate func readResource(_ resource: String) throws -> String {
        let fileURL = try XCTUnwrap(Bundle.module.url(forResource: resource, withExtension: "md"))
        return String((try String(contentsOf: fileURL, encoding: .utf8)).dropLast())
    }
}
