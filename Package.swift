import PackageDescription

let package = Package(
        name: "NStack",
        dependencies: [
                .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1),
        ]
)
