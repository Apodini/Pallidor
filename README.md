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

Because Pallidor is a prototype and currently under active development, there is no guarantee for source-stability.

## Examples
Pallidor includes several script files that demonstrate generating a Swift package for different versions of a Web API. They can executed from the root directory of this repository:

`sh Scripts/{script_directory}/{script_name}.sh -t {target_location_of_package}`

Each script file contains a description of the process to be performed.
 
## Contributing
Contributions to this projects are welcome. Please make sure to read the [contribution guidelines](https://github.com/Apodini/.github/blob/release/CONTRIBUTING.md) first.

## License
This project is licensed under the MIT License. See [License](https://github.com/Apodini/Template-Repository/blob/release/LICENSE) for more information.
