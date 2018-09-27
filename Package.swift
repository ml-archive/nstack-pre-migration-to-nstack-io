import PackageDescription

let package = Package(
        name: "NStack",
        dependencies: [
                .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2),
                .Package(url: "https://github.com/nodes-vapor/sugar.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/vapor/leaf.git", majorVersion: 2)
        ]
)
