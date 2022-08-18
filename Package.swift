// swift-tools-version:5.4
import PackageDescription

let package = Package(
   name: "EventMonitor",
   platforms: [
      .iOS(.v9),
   ],
   products: [
      .library(
         name: "EventMonitor",
         targets: ["EventMonitor"]),
   ],
   dependencies: [
      .package(url: "https://github.com/OlegKetrar/JsonSyntax", .exact("0.2.1")),
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
         ],
         path: "Sources/UI",
         linkerSettings: [
            .linkedFramework("UIKit"),
         ]),

      .target(
         name: "EventMonitor",
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
            .target(name: "EventMonitor"),
         ],
         path: "Tests/Monitor")
   ],
   swiftLanguageVersions: [.v5]
)
