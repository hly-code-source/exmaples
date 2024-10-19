// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

//import PackageDescription
//
//let package = Package(
//    name: "TestSwiftExmaple",
//    targets: [
//        // Targets are the basic building blocks of a package, defining a module or a test suite.
//        // Targets can depend on other targets in this package and products from dependencies.
//        .executableTarget(
//            name: "TestSwiftExmaple"),
//    ]
//)

import PackageDescription

let package = Package(
    name: "TestSwiftExmaple",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .executable(name: "TestSwiftExmaple", targets: ["TestSwiftExmaple"]),
    ],
    dependencies: [
        .package(path: "./MyMath") // 指向 MyMath 模块的相对路径
        // 你可以在这里添加依赖库，比如 SnapKit 或其他库
        // .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0")
//        .package(path: "../MyMath") // 指向 MyMath 模块的相对路径
    ],
    targets: [
        .target(
            name: "TestSwiftExmaple",
            dependencies: ["SnapKit"], // 引用的依赖库
            path: "Sources",           // 代码的路径
            resources: [.process("Resources")], // 如果有资源文件
            linkerSettings: [
                .linkedFramework("UIKit") // 链接 iOS 的系统框架
            ]
        ),
    ]
)
