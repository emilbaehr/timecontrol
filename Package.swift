// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TimeControl",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "TimeControl",
            targets: ["TimeControl"]
        )
    ],
    targets: [
        .target(name: "TimeControl", dependencies: [], path: "Sources"),
        .testTarget(name: "TimeControlTests", dependencies: ["TimeControl"], path: "Tests")
    ]
)
