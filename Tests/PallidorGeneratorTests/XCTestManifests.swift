import XCTest

#if !canImport(ObjectiveC)
/// All tests for PallidorGenerator
/// - Returns: List of XCTestCaseEntries
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(PallidorGeneratorTests.allTests),
        testCase(APITests.allTests),
        testCase(SchemaTests.allTests)
    ]
}
#endif
