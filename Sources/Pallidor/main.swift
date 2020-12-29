import Foundation
import ArgumentParser
import PathKit
import SwiftFormat
import SwiftFormatConfiguration

struct Pallidor : ParsableCommand {
    
    @Option(name: .shortAndLong, help: "If you want to use your own code formatting rules, specify path here")
    var customFormattingRulePath : String?
    
    @Option(name: .shortAndLong, help: "URL of OpenAPI specification of the package to be generated")
    var openapiSpecificationURL : String
    
    @Option(name: .shortAndLong, help: "URL of migration guide of the package to be generated")
    var migrationGuideURL : String?
    
    @Option(name: .shortAndLong, help: "Output path of the package generated")
    var targetDirectory : String
    
    @Option(name: .shortAndLong, help: "Name of the package generated")
    var packageName : String
    
    @Option(name: .shortAndLong, help: "Programming language that the client library should be generated in")
    var language : String = "Swift"
    
    @Option(name: .shortAndLong, help: "Migration strategy indicates which types of changes should be migrated.")
    var strategy : MigrationStrategy = .all
    
    mutating func run() throws {
        
        precondition(!(migrationGuideURL == nil && strategy != .none), "Migration guide must be present for strategies other than 'none'!")
        
        /// prepare formatter
        let codeFormatter = try Formatter(configPath: customFormattingRulePath != nil ? URL(string: customFormattingRulePath!) : nil )
        
        let targetDir = Path(targetDirectory)
        
        /// prepare directories
        let pathHandler = PathHandler(targetDirectory: targetDir, packageName: packageName)
        try pathHandler.createDirectoryStructure()
        
        let specPath = URL(fileURLWithPath: openapiSpecificationURL)
        
        var files = [URL]()
        
        /// generate OpenAPI library
        let generator = Generator(specificationPath: specPath, targetDirectory: targetDir, packageName: packageName)
        
        files.append(contentsOf: try generator.generate())
        
        let facadePath = targetDir + Path(packageName + "/Sources/" + packageName)

        
        /// build facade and perform migration steps
        let migrator = strategy == .none ? try Migrator(targetDirectory: facadePath.string) : try Migrator(targetDirectory: facadePath.string, migrationGuidePath: migrationGuideURL!)
        files.append(contentsOf: try migrator.buildFacade())
        try codeFormatter.format(paths: files)
    }
    
}

Pallidor.main()
