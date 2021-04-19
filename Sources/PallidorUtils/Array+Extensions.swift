import Foundation

public extension Array where Element: Equatable {
    
    /// `contains(_:)` for optionals
    func contains(_ element: Element?) -> Bool {
        guard let element = element else { return false }
        
        return contains(element)
    }
}

public extension Array where Element == String? {
    /// Joins all Strings in Array but skips empty & nil values
    /// - Parameter separator: separator String
    /// - Returns: Joined String
    func skipEmptyJoined(separator: String = "") -> String {
        compactMap { $0 }.skipEmptyJoined(separator: separator)
    }
}

public extension Array where Element == String {
    /// Joins all Strings in Array but skips empty & nil values
    /// - Parameter separator: separator String
    /// - Returns: Joined String
    func skipEmptyJoined(separator: String = "") -> String {
        filter { !$0.isEmpty }.joined(separator: separator)
    }
}

public extension Array {
    /// Sorts the array and maps the `transform` operation
    /// - Parameter transform: method to be executed on each element of array
    /// - Parameter property: the comparable property on which sort is applied to
    /// - Returns: sorted & mapped array
    func sortedMap<T, C: Comparable>(_ transform: (Element) -> T, on property: KeyPath<Element, C>) -> [T] {
        sorted(by: { $0[keyPath: property] < $1[keyPath: property] }).map(transform)
    }
}
