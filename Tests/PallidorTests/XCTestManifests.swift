import XCTest

#if !canImport(ObjectiveC)
/// All tests
/// - Returns: Test cases
public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(PallidorTests.allTests)
    ]
}
#endif
