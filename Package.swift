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
    dependencies: [
        .package(
            url: "https://github.com/XCEssentials/Requirement",
            from: "2.0.0"
        )
    ],
    targets: [
        .target(
            name: "XCEValidatableValue",
            dependencies: [
                "XCERequirement"
            ],
            path: "Sources/Core"
        ),
        .testTarget(
            name: "XCEValidatableValueAllTests",
            dependencies: [
                "XCEValidatableValue",
                "XCERequirement"
            ],
            path: "Tests/AllTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)