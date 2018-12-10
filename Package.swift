// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "NStack",
    products: [
        .library(name: "NStack", targets: ["NStack"]),
        ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.1")
        ],
    targets: [
        .target(name: "NStack", dependencies: ["Vapor", "Leaf"]),
        .testTarget(name: "NStackTests", dependencies: ["NStack"]),
        ]
)
