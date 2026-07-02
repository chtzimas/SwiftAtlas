// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SwiftAtlas",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftAtlasCore",
            targets: ["SwiftAtlasCore"]
        ),
        .executable(
            name: "swiftatlas",
            targets: ["SwiftAtlasCLI"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            from: "603.0.2"
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftAtlasCore",
            dependencies: [
                .product(
                    name: "SwiftSyntax",
                    package: "swift-syntax"
                )
            ]
        ),
        .executableTarget(
            name: "SwiftAtlasCLI",
            dependencies: [
                "SwiftAtlasCore"
            ]
        ),
        .testTarget(
            name: "SwiftAtlasTests",
            dependencies: [
                "SwiftAtlasCore"
            ]
        )
    ]
)
