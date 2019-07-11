// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "XCEValidatableValue",
    products: [
        .library(
            name: "XCEValidatableValue",
            targets: [
                "XCEValidatableValue"
            ]
        )
    ],
    targets: [
        .target(
            name: "XCEValidatableValue",
            path: "Sources/Core"
        ),
        .testTarget(
            name: "XCEValidatableValueAllTests",
            dependencies: [
                "XCEValidatableValue"
            ],
            path: "Tests/AllTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)