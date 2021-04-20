
import Foundation

public extension String {
    var lines: [String] {
        split(separator: "\n").map { String($0) }
    }
    
    /// Used for test cases for catching the first non equal line when comparing to another string
    func firstNonEqualLine(_ rhs: String, function: StaticString = #function, file: StaticString = #file, line: UInt = #line) {
        for (ownLine, rhsLine) in zip(lines, rhs.lines) where ownLine != rhsLine {
            print("Own line: \(ownLine)")
            print("Rhs line: \(rhsLine)")
            fatalError("Found non-equal line in \(function)", file: file, line: line)
        }
    }
    
}
