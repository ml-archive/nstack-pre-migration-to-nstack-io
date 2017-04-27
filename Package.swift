import PackageDescription

let package = Package(
        name: "NStack",
        dependencies: [
                .Package(url: "https://github.com/vapor/vapor.git", Version(2,0,0, prereleaseIdentifiers: ["beta"])),
                .Package(url: "https://github.com/nodes-vapor/sugar.git", Version(2,0,0, prereleaseIdentifiers: ["beta"])),
        ]
)
