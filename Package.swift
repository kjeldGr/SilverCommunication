// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SilverCommunication",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .visionOS(.v1),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "SilverCommunication",
            targets: [
                "SilverCommunication"
            ]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SilverCommunication"
        ),
        .testTarget(
            name: "SilverCommunicationTests",
            dependencies: [
                "SilverCommunication"
            ],
            resources: [
                .copy("Resources/Test.bundle"),
                .process("Resources/file.json")
            ]
        )
    ]
)
