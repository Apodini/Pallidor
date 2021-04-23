import Foundation

/// Describes a path based on the local paths of the files in the project
/// A simpler implementation of `Path` compared with the one implemented in `PathKit`
/// that is sufficient for the logic of `ResourceHandler`
struct Path {
    /// Components of this path
    var components: [String]
    
    /// Parent directory of this path
    private var parentDirectory: Path {
        Path(components.dropLast())
    }
    
    /// True if this path is of form `../../Tests/SomeTargetTests`
    private var isTargetLevel: Bool {
        parentDirectory.last == "Tests"
    }
    
    /// Last path component of this path
    var last: String? {
        components.last
    }
    
    /// The absolute path string of this path based on its `components`
    var absolutePath: String {
        "/" + components.joined(separator: "/")
    }
    
    /// URL of `absolutePath`
    var url: URL {
        URL(fileURLWithPath: absolutePath)
    }
    
    /// Initializes a path from a string, by setting the `components` from the split result of `string` on `/`
    init(_ string: String) {
        components = string.split(separator: "/").map { String($0) }
    }
    
    init(_ components: [String]) {
        self.components = components
    }
    
    /// Used to assert that the file that triggered the functionality is located inside `Tests` folder
    func assert() {
        Swift.assert(components.contains("Tests"), "\(components.last ?? "Resource Handler") must be stored inside `Tests` folder")
    }
    
    /// Moves n-steps back to target level, and one step forward to `Resources` folder
    mutating func cdResources() {
        while !isTargetLevel {
            dropLast()
        }
        components.append("Resources")
    }
    
    /// Returns absolute paths of all children located under this path
    func children() -> [Path] {
        var allFiles: [String] = []
        let enumerator = FileManager.default.enumerator(atPath: absolutePath)
        while let file = enumerator?.nextObject() as? String {
            allFiles.append(file)
        }
        return allFiles.map { self + Path($0) }
    }
    
    /// Removes the last path component of this path (cd ..)
    mutating func dropLast() {
        components = components.dropLast()
    }
    
    /// Returns a new path from the combination of components of `lhs` with `rhs`
    static func + (lhs: Path, rhs: Path) -> Path {
        Path(lhs.components + rhs.components)
    }
}
