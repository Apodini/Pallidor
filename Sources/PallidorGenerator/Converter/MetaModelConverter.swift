//
//  MetaModelConverter.swift
//  
//  Created by Andre Weinkoetz on 21.08.20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import PathKit

/// Converter for all models that are not bound to an open api document
/// but are required for generating a Swift package
struct MetaModelConverter {
    /// Writes all meta models to files
    /// - Parameters:
    ///   - targetDirectory: target where files will be located
    ///   - packageName: name of the package
    ///   - servers: list of server urls from open api document
    /// - Throws: error if files could not be written
    /// - Returns: list of file urls
    func writeToFile(targetDirectory: Path, packageName: String, servers: [String]) throws -> [URL] {
        let path = targetDirectory + Path(packageName + "/Sources/" + packageName)
        let testPath = targetDirectory + Path(packageName + "/Tests/" + packageName + "Tests/")
    
        var filePaths = [URL]()

        let packageSwiftPath = targetDirectory + Path("\(packageName)/Package.swift")
        let packageFile = ResourceReader.read(.PackageModel)
        try packageFile.replacingOccurrences(
            of: "###PLACEHOLDER###",
            with: packageName
        )
        .write(to: packageSwiftPath.url, atomically: true, encoding: .utf8)
        filePaths.append(packageSwiftPath.url)

        let networkManagerPath = path + Path("NetworkManager.swift")
        let code = ResourceReader.read(.NetworkManagerModel)
        try code.replacingOccurrences(
            of: "###PLACEHOLDER###",
            with: !servers.isEmpty ? servers.description : "[]"
        )
        .write(to: networkManagerPath.url, atomically: true, encoding: .utf8)
        filePaths.append(networkManagerPath.url)

        let httpAuthPath = path + Path("HTTPAuthorization.swift")
        try ResourceReader.read(.HTTPAuthorizationModel).write(to: httpAuthPath.url, atomically: true, encoding: .utf8)
        filePaths.append(httpAuthPath.url)

        let testFilePath = testPath + Path("\(packageName)Tests.swift")
        let testFile = ResourceReader.read(.TestFileModel)
        try testFile.replacingOccurrences(
            of: "###PLACEHOLDER###",
            with: packageName
        )
        .write(to: testFilePath.url, atomically: true, encoding: .utf8)
        filePaths.append(testFilePath.url)

        let testManifestPath = testPath + Path("XCTestManifests.swift")
        let manifestFile = ResourceReader.read(.TestManifestModel)
        try manifestFile.replacingOccurrences(
            of: "###PLACEHOLDER###",
            with: packageName
        )
        .write(to: testManifestPath.url, atomically: true, encoding: .utf8)
        filePaths.append(testManifestPath.url)
        
        let linuxMainPath = targetDirectory + Path(packageName + "/Tests/" + "LinuxMain.swift")
        let linuxFile = ResourceReader.read(.LinuxMainModel)
        try linuxFile.replacingOccurrences(
            of: "###PLACEHOLDER###",
            with: packageName
        )
        .write(to: linuxMainPath.url, atomically: true, encoding: .utf8)
        filePaths.append(linuxMainPath.url)

        let errorURL = path + Path("_APIErrors.swift")
        try OpenAPIErrorModel().description.write(to: errorURL.url, atomically: true, encoding: .utf8)
        filePaths.append(errorURL.url)
        
        return filePaths
    }
}
