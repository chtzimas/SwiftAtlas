// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Fixture",
    targets: [
        .target(name: "FeatureA"),
        .target(name: "FeatureB", dependencies: ["FeatureA"]),
        .testTarget(name: "FeatureATests")
    ]
)
