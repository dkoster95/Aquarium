// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Aquarium",
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
