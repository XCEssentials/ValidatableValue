// swift-tools-version:5.3

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
            name: "XCERequirement",
            url: "https://github.com/XCEssentials/Requirement",
            from: "2.2.0"
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
    ]
)