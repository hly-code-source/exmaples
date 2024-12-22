// MyMath/Package.swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyMath",
    products: [
        .library(
            name: "MyMath",
            targets: ["MyMath"]),
    ],
    targets: [
        .target(
            name: "MyMath",
            dependencies: []),
        .testTarget(
            name: "MyMathTests",
            dependencies: ["MyMath"]),
    ]
)
