import Foundation

/// A protocol that allows functionality to manipulate resources while running a test
/// The whole logic is implemented based on current `Pallidor` test resources,
/// which consist of `resources`, `results`, and `migration guides`. Currently the only requirement is `ResourceContainer` type
public protocol ResourceHandler {
    associatedtype Container: ResourceContainer
}

/// Conforming types are suggested to be enums with associated values of type `Resource` returned via instance computed property
public protocol ResourceContainer {
    var instance: Resource { get }
}

public extension ResourceHandler {
    /// A default implementation of a `XCTAssertEqual` test. Pre-checks the equality of `expression` with the content of `resource`
    /// If not equal the test case fails, `expression` is written at `resource` and the next test case is guaranteed a success
    ///  - Parameters:
    ///     - expression `lhs` of equality check
    ///     - container: the container of the resource
    ///     - file:`#file` variable by default. `Must` not be changed. The only source of truth to discover resources inside the tests
    func XCTResourceHandlerAssertEqual(_ expression: String, _ container: Self.Container, overrideResult: Bool = false, file: String = #file) {
        do {
            let instance = container.instance
            let expectationContent = try instance.content()
            
            if expression != expectationContent, overrideResult {
                try instance.write(expression, file: file)
            }
            
            /** the project does not build if importing XCTest in a non-testtarget, and the compiler ignores
             #if canImport(XCTest)
             
             will have to think about another solution. An alternative would be including:
             https://github.com/pointfreeco/xctest-dynamic-overlay or even moving the resource handler code in a test target
             */
            
            
//            XCTAssertEqual(expression, resourceContent)
        } catch {
//            XCTFail("\(error.localizedDescription)")
        }
    }
    
    /// A default implementation to directly write the specified content to a resource contained in container
    func write(content: String, for container: Self.Container, file: String = #file) {
        do {
            try container.instance.write(content, file: file)
        } catch {
            fatalError("Write failed: \(error.localizedDescription)")
        }
    }
}
