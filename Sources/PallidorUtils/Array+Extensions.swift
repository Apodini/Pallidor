import Foundation

extension Array where Element: Equatable {
    
    /// Overloads `contains(_:)` to support optionals
    func contains(_ element: Element?) -> Bool {
        guard let element = element else { return false }
        
        return contains(element)
    }
}
