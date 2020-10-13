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
    
    mutating func run() throws {
        
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
        let migrator = try Migrator(targetDirectory: facadePath.string, migrationGuidePath: migrationGuideURL!)
        files.append(contentsOf: try migrator.buildFacade())
        try codeFormatter.format(paths: files)
    }
    
}

Pallidor.main()