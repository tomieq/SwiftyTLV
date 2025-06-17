// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwiftyTLV",
    products: [
        .library(
            name: "SwiftyTLV",
            targets: ["SwiftyTLV"])
    ],
    dependencies: [
        .package(url: "https://github.com/tomieq/SwiftExtensions", branch: "master")
    ],
    targets: [
        .target(
            name: "SwiftyTLV",
            dependencies: [
                .product(name: "SwiftExtensions", package: "SwiftExtensions")
            ],
            path: "Sources"),
        .testTarget(
            name: "SwiftyTLVTests",
            dependencies: ["SwiftyTLV"],
            path: "Tests")
    ]
)
