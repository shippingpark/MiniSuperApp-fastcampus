// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    products: [
        .library(
            name: "CombineUtil",
            targets: ["CombineUtil"])
    ],
    dependencies: [
      .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "CombineUtil",
            dependencies: [
              "CombineExt"
            ]
        ),
    ]
)
