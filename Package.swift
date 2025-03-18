// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SilverCommunication",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12),
        .visionOS(.v1),
        .watchOS(.v4)
    ],
    products: [
        .library(
            name: "SilverCommunication",
            targets: [
                "SilverCommunication"
            ]
        )
    ],
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