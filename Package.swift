// swift-tools-version:5.4
import PackageDescription

let package = Package(
   name: "NetworkMonitor",
   platforms: [
      .iOS(.v9),
   ],
   products: [
      .library(
         name: "NetworkMonitor",
         targets: ["NetworkMonitor"]),
   ],
   dependencies: [
      .package(url: "https://github.com/OlegKetrar/JsonSyntax", .exact("0.2.1")),
      .package(name: "DependencyContainer", path: "../DependencyContainer"),
   ],
   targets: [
      .target(
         name: "MonitorCore",
         path: "Sources/Core"),

      .target(
         name: "MonitorUI",
         dependencies: [
            .product(name: "JsonSyntax-Static", package: "JsonSyntax"),
            .target(name: "MonitorCore"),
            .product(name: "DependencyContainer", package: "DependencyContainer"),
            // ToolsFoundation.Reusable ?
         ],
         path: "Sources/UI",
         linkerSettings: [
            .linkedFramework("UIKit"),
         ]),

      .target(
         name: "NetworkMonitor",
         dependencies: [
            .target(name: "MonitorCore"),
            .target(name: "MonitorUI"),
         ],
         path: "Sources/Monitor",
         linkerSettings: [
            .linkedFramework("UIKit"),
         ]),

      .testTarget(
         name: "MonitorTests",
         dependencies: [
            .target(name: "NetworkMonitor"),
         ],
         path: "Tests/Monitor")
   ],
   swiftLanguageVersions: [.v5]
)
