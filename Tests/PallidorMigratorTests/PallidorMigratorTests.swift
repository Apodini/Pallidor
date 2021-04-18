// Force try is disabled for lines that refer to fetching and parsing
import XCTest
import PathKit
import SourceryFramework
@testable import PallidorMigrator

final class PallidorMigratorTests: XCTestCase {
    func testSemanticVersion() {
        let oldVersion = SemanticVersion(versionString: "1.0.1")
        let newVersion = SemanticVersion(versionString: "1.0.11")
        let newerVersion = SemanticVersion(versionString: "1.2.0")
        let majorNewVersion = SemanticVersion(versionString: "2.0.1")
        
        XCTAssertTrue(oldVersion < newVersion)
        XCTAssertTrue(oldVersion <= newVersion)
        XCTAssertTrue(newVersion >= oldVersion)
        XCTAssertTrue(newerVersion >= oldVersion)
        XCTAssertTrue(newVersion > oldVersion)
        XCTAssertFalse(newVersion >= newerVersion)
        XCTAssertTrue(majorNewVersion > newVersion)
        XCTAssertTrue(majorNewVersion > newerVersion)
        XCTAssertTrue(majorNewVersion > oldVersion)
        XCTAssertFalse(majorNewVersion == newerVersion)
    }
    
    func testTypeIdentification() {
        // swiftlint:disable:next force_try
        let enumCode = try! FileParser(contents: "public enum Status : String, CaseIterable, Codable {}" ).parse()
        let enumType = WrappedTypes(types: enumCode.types)
        
        XCTAssertTrue(enumType.type == .enum)
        XCTAssertFalse(enumType.type == .class)
        
        // swiftlint:disable:next force_try
        let classCode = try! FileParser(contents: "public class Pet : Codable {}" ).parse()
        let classType = WrappedTypes(types: classCode.types)
        
        XCTAssertTrue(classType.type == .class)
        XCTAssertFalse(classType.type == .struct)
        
        // swiftlint:disable:next force_try
        let structCode = try! FileParser(contents: "public struct UserAPI : Codable {}" ).parse()
        let structType = WrappedTypes(types: structCode.types)
        
        XCTAssertTrue(structType.type == .struct)
        XCTAssertFalse(structType.type == .enum)
    }

    static var allTests = [
        ("testTypeIdentification", testTypeIdentification),
        ("testSemanticVersion", testSemanticVersion)
    ]
}
