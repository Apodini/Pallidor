// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Pallidor",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(name: "Pallidor", targets: [ "Pallidor" ])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-format.git", .branch("swift-5.3-branch")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.3.1")),
        .package(url: "https://github.com/Apodini/PallidorGenerator.git", .branch("develop")),
        .package(url: "https://github.com/Apodini/PallidorMigrator.git", .branch("develop"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Pallidor",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftFormat", package: "swift-format"),
                .product(name: "PallidorGenerator", package: "PallidorGenerator"),
                .product(name: "PallidorMigrator", package: "PallidorMigrator")
            ]),
        .testTarget(
            name: "PallidorTests",
            dependencies: ["Pallidor", "PallidorGenerator", "PallidorMigrator"],
            resources: [
                .process("Resources/openapi.md"),
                .process("Resources/migrationguide.md")
            ])
    ]
)
