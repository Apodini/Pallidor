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
    /// A default implementation to directly write the specified content to a resource contained in container
    func write(content: String, for container: Self.Container, file: String = #file) {
        do {
            try container.instance.write(content, file: file)
        } catch {
            fatalError("Write failed: \(error.localizedDescription)")
        }
    }
}
