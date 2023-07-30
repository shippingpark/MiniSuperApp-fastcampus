// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [.iOS(.v14)], //플랫폼도 버전을 맞춰줘야 한다
    products: [
        .library(
            name: "CombineUtil",
            targets: ["CombineUtil"]),
        
          .library(
              name: "RIBsUtil", //RIBs의 일반적인 유틸
              targets: ["RIBsUtil"]),
        .library(
            name: "SuperUI",
            targets: ["SuperUI"]),
    ],
    
    dependencies: [
      .package(url: "https://github.com/CombineCommunity/CombineExt.git", from: "1.0.0"),
      .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "CombineUtil",
            dependencies: [
              "CombineExt"
            ]
        ),
        .target(
            name: "RIBsUtil",
            dependencies: [
              "ModernRIBs"
            ]
        ),
        .target(
            name: "SuperUI",
            dependencies: [
              "RIBsUtil"
            ]
        ),
    ]
)
