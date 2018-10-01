// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "NStack",
    products: [
        .library(name: "NStack", targets: ["NStack"]),
        ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        // required for MutableLeafTagConfig
        .package(url: "https://github.com/nodes-vapor/sugar.git", from: "3.0.0-beta")
        ],
    targets: [
        .target(name: "NStack", dependencies: ["Vapor", "Sugar"]),
        .testTarget(name: "NStackTests", dependencies: ["NStack"]),
        ]
)
