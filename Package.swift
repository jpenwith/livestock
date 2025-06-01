// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Livestock",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Livestock",
            targets: ["Livestock"]
        ),
        .library(
            name: "Livestock+Fluent",
            targets: ["Livestock+Fluent"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.110.1"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Livestock",
            swiftSettings: [
                .unsafeFlags(["-enable-bare-slash-regex"])
            ]
        ),
        .target(
            name: "Livestock+Fluent",
            dependencies: [
                "Livestock",

                .product(name: "Fluent", package: "fluent"),
                .product(name: "Vapor", package: "vapor"),
            ]
        ),
        .testTarget(
            name: "LivestockTests",
            dependencies: ["Livestock"]
        ),
    ]
)
