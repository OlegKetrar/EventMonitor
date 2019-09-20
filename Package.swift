// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "NetworkMonitor",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "NetworkMonitor",
            type: .dynamic,
            targets: ["NetworkMonitor"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "NetworkMonitor",
            dependencies: [],
            path: "Sources"),
    ],
    swiftLanguageVersions: [.v5]
)
