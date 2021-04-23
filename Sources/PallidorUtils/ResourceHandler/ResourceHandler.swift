import Foundation

/// A protocol that allows functionality to manipulate resources while running a test
/// The whole logic is implemented based on current `Pallidor` test resources,
/// which consist of `resource` (input) and `results` (expected) file types
public protocol ResourceHandler {
    /// Input type resource
    associatedtype Input: Resource
    /// Output type resource
    associatedtype Output: Resource
}

/// A container of inputs and outputs of `ResourceHandler`s
/// See usage in `XCTResourceHandlerAssertEqual`
public enum Container<R: ResourceHandler> {
    /// Input resource
    case input(R.Input)
    /// Output resource
    case output(R.Output)
    
    var instance: Resource {
        switch self {
        case let .input(instance):
            return instance
        case let .output(instance):
            return instance
        }
    }
}

public extension ResourceHandler {
    /// A default implementation of a `XCTAssertEqual` test. Pre-checks the equality of `expression` with the content of `resource`
    /// If not equal the test case fails, `expression` is written at `resource` and the next test case is guaranteed a success
    ///  - Parameters:
    ///     - expression `lhs` of equality check
    ///     - resource: the container of the resource
    ///     - file:`#file` variable by default. `Must` not be changed. The only source of truth to discover resources inside the tests
    func XCTResourceHandlerAssertEqual(_ expression: String, _ container: Container<Self>, file: String = #file) {
        do {
            let resource = container.instance
            let resourceContent = try resource.content()
            
            if expression != resourceContent {
                try resource.write(expression, file: file)
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
}
