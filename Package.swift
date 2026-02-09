// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Aquarium",
    platforms: [.iOS(.v15),
                .watchOS(.v7),
                .macOS(.v12),
                .tvOS(.v14)],
    products: [
        .library(
            name: "Aquarium",
            targets: ["Aquarium"]),
    ],
    targets: [
        .target(
            name: "Aquarium"),
        .testTarget(
            name: "AquariumTests",
            dependencies: ["Aquarium"]
        ),
    ]
)
