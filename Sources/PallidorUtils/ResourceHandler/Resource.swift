import Foundation

/// Represent different cases of file extensions
public enum FileExtension: CustomStringConvertible {
    /// Markdown
    case markdown
    /// JSON
    case json
    /// Swift
    case swift
    /// Text
    case text
    /// Other
    case other(String)
    
    /// String representation this extension
    public var description: String {
        switch self {
        case .markdown: return "md"
        case .json: return "json"
        case .swift: return "swift"
        case .text: return "txt"
        case let .other(value): return value
        }
    }
}

/// A protocol to allow manipulation of bundle resources
/// Conforming types should specify the `Bundle` where the resources are stored and the name of the file
/// By default `fileExtension` is set to `markdown`. `content()` and `data()` functions also provide default implementations
public protocol Resource {
    /// File extension of this resource
    var fileExtension: FileExtension { get }
    /// Name of the resource file (without extension)
    var name: String { get }
    /// Bundle where this resource is stored
    var bundle: Bundle { get }
    
    /// The read operations of these functions are performed from the `bundle`
    /// Returns string content of the resource
    func content() throws -> String
    /// Returns the raw data of this resource.
    func data() throws -> Data
}

/// Default internal implementations
extension Resource {
    var fileName: String {
        "\(name).\(fileExtension.description)"
    }
    
    var fileURL: URL {
        guard let fileURL = bundle.url(forResource: name, withExtension: fileExtension.description) else {
            fatalError("Resource \(name) not found")
        }
        
        return fileURL
    }
    
    /// Writes and persists `content` at this resource. The write operation is performed in the local project folder
    /// (internal to hide the logic)
    /// - Parameters:
    ///   - content: the content that should be writen to the resource
    ///   - file:`#file` variable of the file that initialized the call hierarchy. Retrived from `XCTResourceHandlerAssertEqual`
    func write(_ content: String, file: String) throws {
        var path = Path(file)
        
        path.assert()
        
        path.cdResources()
        
        let children = path.children()
        
        guard let resourcePath = children.first(where: { $0.last == fileName }) else {
            return
        }
        
        try content.write(to: resourcePath.url, atomically: true, encoding: .utf8)
    }
}

/// Default public implementations
public extension Resource {
    var fileExtension: FileExtension { .markdown }
    
    func content() throws -> String {
        try String(contentsOf: fileURL, encoding: .utf8)
    }
    
    func data() throws -> Data {
        try Data(contentsOf: fileURL)
    }
}
