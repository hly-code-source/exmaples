// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Person",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_13),
        .tvOS(.v12)
    ],
    products: [
//        .library(name: "Person", targets: ["Person"]),
        .library(name: "Person-Dynamic", type: .dynamic, targets: ["Person"]),
    ],
    targets: [
        .target(name: "Person", path: "Sources"),
    ],
    swiftLanguageModes: [
        .v5
    ]
)
