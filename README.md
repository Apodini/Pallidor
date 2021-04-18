# Pallidor

<p align="center">
  <img width="150" src="https://github.com/Apodini/Pallidor/blob/develop/Images/pallidor-icon.png">
</p>

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/Swift-5.3-blue.svg" alt="Swift 5.3">
    </a>
  <a href="https://github.com/Apodini/Pallidor">
    <img src="https://github.com/Apodini/Pallidor/workflows/Build%20and%20Test/badge.svg" alt="Build and Test">
    </a>
</p>

**Pallidor** is a commandline tool that generates a Swift package based on an OpenAPI specification and automatically migrates it according to changes specified in a machine-readable migration guide. 

## Requirements
Executing Pallidor requires at least Swift 5.3 and macOS 10.15.

If executing Pallidor fails, make sure to add the following symbolic link to SwiftSyntax:

`ln -s $(xcode-select -p)/../Frameworks/lib_InternalSwiftSyntaxParser.dylib /usr/local/lib`

## Usage
Use Pallidor via the commandline or integrate the binaries into your CI/CD system.
By running `swift run Pallidor -h` all available commands are displayed.
```
swift run Pallidor -h
USAGE: pallidor [--custom-formatting-rule-path <custom-formatting-rule-path>] --openapi-specification-url <openapi-specification-url> [--migration-guide-url <migration-guide-url>] --target-directory <target-directory> --package-name <package-name> [--language <language>] [--strategy <strategy>]

OPTIONS:
  -c, --custom-formatting-rule-path <custom-formatting-rule-path>
                          If you want to use your own code formatting rules, specify path here 
  -o, --openapi-specification-url <openapi-specification-url>
                          URL of OpenAPI specification of the package to be generated 
  -m, --migration-guide-url <migration-guide-url>
                          URL of migration guide of the package to be generated 
  -t, --target-directory <target-directory>
                          Output path of the package generated 
  -p, --package-name <package-name>
                          Name of the package generated 
  -l, --language <language>
                          Programming language that the client library should be generated in (default: Swift)
  -s, --strategy <strategy>
                          Migration strategy indicates which types of changes should be migrated. (default: all)
  -h, --help              Show help information.

```

 - Pallidor uses [swift-format](https://github.com/apple/swift-format) to apply formatting rules according to your configuration. Its path can be specified using the `-c` parameter. If no configuration file is provided, a default configuration is used.
 - It's required to set the package's name and its target directory by using the `-p` and `-t` parameters.
 - The URLs of a Web API's specification and corresponding migration guide are provided using the `-o` and `-m` parameters. The files can be located locally or on a remote web server.
 - Since Pallidor is a prototype, only Swift is supported as the target language. Furthermore, only two strategies can be used: `all` (migrates all changes including deletions) and `none` (does not migrate changes, derives the facade layer directly from the library layer)

## Examples
Pallidor includes several script files that demonstrate generating a Swift package for different versions of a Web API. They can executed from the root directory of this repository:

`sh Scripts/{script_directory}/{script_name}.sh -t {target_location_of_package}`

Each script file contains a description of the process to be performed.

## Pallidor Generator

`PallidorGenerator` is a part of Pallidor, and can be used to parse OpenAPI specifications and generate the library layer of a Swift package for client applications. To integrate the `PallidorGenerator` library in your SwiftPM project, add the following line to the dependencies in your `Package.swift` file:
```swift
.package(url: "https://github.com/Apodini/Pallidor.git", .branch("develop"))
```
and include the dependency:

```swift
.product(name: "PallidorGenerator", package: "Pallidor")
```

### Usage
To get started with `PallidorGenerator` you first need to create an instance of it, providing the path to the directory in which the source files are located, as well as the content of the OpenAPI specification (v3):
```swift
var specification : String = ...
let generator = try PallidorGenerator(specification: specification)
```
To start generating the OpenAPI library, you need to call the `generate()` method, providing a `Path` to the target directory where the generated files should be located and a `name` for the package.
```swift
var path: Path = ...
var packageName: String = ...
try generator.generate(target: path, package: packageName)
```
All generated API files will be located under `{targetDirectory}/Models` or `{targetDirectory}/APIs`.
Additionally several meta files which are required for a SPM library are also generated and located under their respective folder in `{targetDirectory}`.

## Pallidor migrator
Pallidor additionally offers `PallidorMigrator`, a Swift library that generates a persistent facade layer for accessing a Web API dependency. Therefore, it incorporates all changes stated in a machine-readable migration guide into the internals of the facade.

### Usage
To get started with `PallidorMigrator` you first need to create an instance of it, providing the path to the directory in which the source files are located, and the textual representation of the migration guide:
```swift
let targetDirectory : String = ...
let migrationGuide : String = ...
let migrator = try PallidorMigrator(targetDirectory: targetDirectory, migrationGuideContent: migrationGuide)
```
To start with generating the persistent facade, you call the `buildFacade()` method:
```swift
try migrator.buildFacade()
```
All generated facade files will be located under `{targetDirectory}/PersistentModels` or `{targetDirectory}/PersistentAPIs`

## Documentation
The documentation for this package is generated with [jazzy](https://github.com/realm/jazzy) and can be found [here](https://apodini.github.io/Pallidor/).
 
## Contributing
Contributions to this projects are welcome. Please make sure to read the [contribution guidelines](https://github.com/Apodini/.github/blob/release/CONTRIBUTING.md) first.

## License
This project is licensed under the MIT License. See [License](https://github.com/Apodini/Template-Repository/blob/release/LICENSE) for more information.
