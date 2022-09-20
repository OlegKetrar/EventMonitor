// swift-tools-version:5.4
import PackageDescription

let package = Package(
   name: "EventMonitor",
   platforms: [
      .iOS(.v13),
   ],
   products: [
      .library(
         name: "EventMonitor",
         targets: ["EventMonitor"]),

      .library(
         name: "MonitorSwiftUITest",
         targets: ["MonitorSwiftUITest"]),

      .library(
         name: "MonitorCoreV2",
         targets: ["MonitorCoreV2"]),
   ],
   dependencies: [
      .package(url: "https://github.com/OlegKetrar/JsonSyntax", .exact("0.2.1")),
   ],
   targets: [
      .target(
         name: "MonitorCore",
         path: "Sources/Core"),

      .target(
         name: "MonitorCoreV2",
         path: "Sources/CoreV2"),

      .target(
         name: "MonitorSwiftUITest",
         dependencies: ["MonitorCoreV2"],
         path: "Sources/SwiftUITest"),

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
