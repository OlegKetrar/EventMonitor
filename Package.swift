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
   dependencies: [],
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
            .target(name: "JsonSyntax"),
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

      .target(
        name: "JsonSyntax",
        path: "Sources/JsonSyntax"),
   ],
   swiftLanguageVersions: [.v5]
)
