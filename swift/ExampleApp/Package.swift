// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExampleApp",
    dependencies: [
        .package(path: "../MyMath") // 指向 MyMath 模块的相对路径
    ],
     targets: [
        .target(
            name: "ExampleApp",
            dependencies: ["MyMath"]),
        // .testTarget(
        //     name: "ExampleAppTests",
        //     dependencies: ["ExampleApp"]),
    ]
)
