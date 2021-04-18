import Foundation
import OpenAPIKit
import PathKit
import Yams

/// Entry for Pallidor Generator
public struct PallidorGenerator {
    /// Parsed open api specification from OpenAPIKit
    var resolvedDocument: ResolvedDocument
    
    
    /// Initializes the Pallidor Generator
    /// - Parameter path: URL to OpenAPI specification
    /// - Throws: Error if Document cannot be decoded or resolved
    public init(specification path: URL) throws {
        let decoder = JSONDecoder()
        let document = try decoder.decode(OpenAPI.Document.self, from: Data(contentsOf: path))
        self.resolvedDocument = try document.locallyDereferenced().resolved()
    }
    
    /// Initializes the Pallidor Generator
    /// - Parameter content: Content of the OpenAPI specification
    /// - Throws: Error if Document cannot be decoded or is malformed
    public init(specification content: String) throws {
        let decoder = JSONDecoder()
        guard let data = content.data(using: .utf8) else {
            fatalError("Specification content could not be read.")
        }
        let document = try decoder.decode(OpenAPI.Document.self, from: data)
        self.resolvedDocument = try document.locallyDereferenced().resolved()
    }
    
    
    /// Generates the library code
    /// - Parameters:
    ///   - path: target directory where output should be located
    ///   - name: name of the package to be generated
    /// - Throws: Error if writing files fails
    /// - Returns: List of file URLs from generated code
    public func generate(target path: Path, package name: String) throws -> [URL] {
        let modelPath = path + Path("\(name)/Sources/\(name)/Models")
        let apiPath = path + Path("\(name)/Sources/\(name)/APIs")
        
        var filePaths = [URL]()
        
        let servers = resolvedDocument.allServers.map { $0.urlTemplate.absoluteString }
        
        TypeAliases.parse(resolvedDoc: resolvedDocument)
        
        var modelConverter = SchemaConverter(resolvedDocument)
        var apiConverter = APIConverter(resolvedDocument)
        let metaModelConverter = MetaModelConverter()
        
        modelConverter.parse()
        apiConverter.parse()
        
        filePaths.append(contentsOf: try modelConverter.writeToFile(path: modelPath))
        filePaths.append(contentsOf: try apiConverter.writeToFile(path: apiPath))
        filePaths.append(contentsOf: try metaModelConverter.writeToFile(targetDirectory: path, packageName: name, servers: servers))
        
        return filePaths
    }
}
