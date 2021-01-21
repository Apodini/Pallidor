import Foundation
import ArgumentParser
import Combine
import PathKit
import SwiftFormat
import SwiftFormatConfiguration

struct Pallidor: ParsableCommand {
    @Option(name: .shortAndLong, help: "If you want to use your own code formatting rules, specify path here")
    /// Custom code formatting rules
    var customFormattingRulePath: String?
    
    @Option(name: .shortAndLong, help: "URL of OpenAPI specification of the package to be generated")
    /// URL of OpenAPI specification of the package to be generated
    var openapiSpecificationURL: String
    
    @Option(name: .shortAndLong, help: "URL of migration guide of the package to be generated")
    /// URL of migration guide of the package to be generated
    var migrationGuideURL: String?
    
    @Option(name: .shortAndLong, help: "Output path of the package generated")
    /// Output path of the package generated
    var targetDirectory: String
    
    @Option(name: .shortAndLong, help: "Name of the package generated")
    /// Name of the package generated
    var packageName: String
    
    @Option(name: .shortAndLong, help: "Programming language that the client library should be generated in")
    /// Programming language that the client library should be generated in
    var language: String = "Swift"
    
    @Option(name: .shortAndLong, help: "Migration strategy indicates which types of changes should be migrated.")
    /// Indicates which types of changes should be migrated.
    var strategy: MigrationStrategy = .all
    
    /// Starts migration process
    func run() throws {
        precondition(
            !(migrationGuideURL == nil && strategy != .none),
            "Migration guide must be present for strategies other than 'none'!"
        )
        
        var cancellables: Set<AnyCancellable> = []
        /// prepare formatter
        let codeFormatter = try Formatter(configPath: customFormattingRulePath)
        
        let getSpec = getSpecification(url: openapiSpecificationURL)
            .sink { com in
                switch com {
                case .failure(let err):
                    print(err)
                case .finished:
                    break
                }
            } receiveValue: { openAPISpec in
                do {
                    try codeFormatter.format(paths: self.generateLibraryLayer(specification: openAPISpec))
                    
                    guard let migrationGuideURL = migrationGuideURL else {
                        try codeFormatter.format(paths: self.generateFacadeLayer(migrationGuide: nil))
                        Pallidor.exit()
                    }
                    
                    getMigrationGuide(url: migrationGuideURL)
                        .sink { com in
                            switch com {
                            case .failure(let err):
                                print(err)
                            case .finished:
                                break
                            }
                        } receiveValue: { migrationGuide in
                            do {
                                try codeFormatter.format(
                                    paths: self.generateFacadeLayer(migrationGuide: migrationGuide)
                                )
                                Pallidor.exit()
                            } catch {
                                fatalError("Error in generating facade layer.")
                            }
                        }
                        .store(in: &cancellables)
                } catch {
                    fatalError("Error in generating library layer.")
                }
            }
        
        cancellables.insert(getSpec)
        RunLoop.main.run()
    }
    
    fileprivate func generateLibraryLayer(specification: String) -> [URL] {
        var files = [URL]()
        
        let targetDir = Path(targetDirectory)
        
        /// prepare directories
        let pathHandler = PathHandler(targetDirectory: targetDir, packageName: packageName)
        do {
            try pathHandler.createDirectoryStructure()
        } catch {
            fatalError("Directory structure could not be created.")
        }
        
        /// generate OpenAPI library
        let generator = Generator(specification: specification, targetDirectory: targetDir, packageName: packageName)
        
        guard let result = try? generator.generate() else {
            fatalError("Error in generating library layer.")
        }
        
        files.append(contentsOf: result)
        
        return files
    }
    
    fileprivate func generateFacadeLayer(migrationGuide: String?) -> [URL] {
        var files = [URL]()
        
        let targetDir = Path(targetDirectory)
        
        let facadePath = targetDir + Path(packageName + "/Sources/" + packageName)

        /// build facade and perform migration steps
        guard let migrator = try? Migrator(
            targetDirectory: facadePath.string,
            migrationGuide: migrationGuide
        ) else {
            fatalError("Migrator could not be initialized.")
        }

        guard let result = try? migrator.buildFacade() else {
            fatalError("Error in generating facade layer.")
        }
        
        files.append(contentsOf: result)

        return files
    }
    
    fileprivate func getMigrationGuide(url: String) -> AnyPublisher<String, Error> {
        if url.hasPrefix("http") {
            guard let requestURL = URL(string: url) else {
                fatalError("Request URL is malformed.")
            }
            return URLSession.shared.dataTaskPublisher(for: requestURL)
                .tryMap { data, _ in
                    guard let result = String(data: data, encoding: .utf8) else {
                        fatalError("Migration guide could not be read from remote URL.")
                    }
                    return result
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            let migrationPath = URL(fileURLWithPath: url)
            guard let content = try? String(contentsOf: migrationPath, encoding: .utf8) else {
                fatalError("Migration guide could not be read from local URI.")
            }
            return CurrentValueSubject<String, Error>(content).eraseToAnyPublisher()
        }
    }
    
    fileprivate func getSpecification(url: String) -> AnyPublisher<String, Error> {
        if url.hasPrefix("http") {
            guard let requestURL = URL(string: url) else {
                fatalError("Request URL is malformed.")
            }
            return URLSession.shared.dataTaskPublisher(for: requestURL)
                .tryMap { data, _ in
                    guard let result = String(data: data, encoding: .utf8) else {
                        fatalError("OpenAPI specification could not be read from remote URL.")
                    }
                    return result
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            let specPath = URL(fileURLWithPath: url)
            guard let content = try? String(contentsOf: specPath, encoding: .utf8) else {
                fatalError("OpenAPI specification could not be read from local URI.")
            }
            return CurrentValueSubject<String, Error>(content).eraseToAnyPublisher()
        }
    }
}

Pallidor.main()
