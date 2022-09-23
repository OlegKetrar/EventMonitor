// swift-tools-version:5.7
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
   ],
   dependencies: [
      .package(url: "https://github.com/OlegKetrar/JsonSyntax", exact: "0.2.1"),
   ],
   targets: [
      .target(
         name: "MonitorCore",
         path: "Sources/Core"),

      .testTarget(
         name: "CoreTests",
         dependencies: [
            .target(name: "MonitorCore"),
         ],
         path: "Tests/Core"),

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
         path: "Sources/Composer",
         linkerSettings: [
            .linkedFramework("UIKit"),
         ]),

      .testTarget(
         name: "ComposerTests",
         dependencies: [
            .target(name: "EventMonitor"),
         ],
         path: "Tests/Composer"),
   ],
   swiftLanguageVersions: [.v5]
)
