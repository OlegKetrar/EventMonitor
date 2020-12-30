// swift-tools-version:5.2
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
   dependencies: [
      .package(url: "https://github.com/OlegKetrar/JsonSyntax", .exact("0.2.1")),
   ],
   targets: [
      .target(
         name: "NetworkMonitor",
         dependencies: [
            .product(name: "JsonSyntax-Static", package: "JsonSyntax"),
         ],
         path: "Sources",
         linkerSettings: [
            .linkedFramework("UIKit"),
         ]),
   ],
   swiftLanguageVersions: [.v5]
)
