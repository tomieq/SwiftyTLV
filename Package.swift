// swift-tools-version:4.0
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
    ],
    targets: [
        .target(
            name: "SwiftyTLV",
            path: "Sources"),
        .testTarget(
            name: "SwiftyTLVTests",
            dependencies: ["SwiftyTLV"],
            path: "Tests")
    ]
)
