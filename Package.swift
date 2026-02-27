// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "NativeTamo",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
    ],
    targets: [
        .executableTarget(
            name: "NativeTamo",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
