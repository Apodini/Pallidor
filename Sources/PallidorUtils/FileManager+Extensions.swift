import Foundation

public extension FileManager {
    /// Returns a list of all swift file names inside a directory
    /// - Parameter path: path string of directory
    /// - Returns: list of all file names
    static func swiftFilesInDirectory(atPath path: String) -> [String] {
        filesInDirectory(atPath: path, ofType: .swift)
    }
    
    /// Returns a list of all file names inside a directory
    /// - Parameters
    ///     - path: path string of directory
    ///     - ofType: file extension of the files
    /// - Returns: list of all file names
    static func filesInDirectory(atPath path: String, ofType type: FileExtension) -> [String] {
        let filePaths = (try? `default`.contentsOfDirectory(atPath: path)) ?? []
        return filePaths.filter { $0.hasSuffix(".\(type.description)") }
    }
}
