// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TimeControl",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "TimeControl",
            targets: ["TimeControl"]
        )
    ],
    targets: [
        .target(name: "TimeControl", dependencies: [], path: "Sources"),
    ]
)
