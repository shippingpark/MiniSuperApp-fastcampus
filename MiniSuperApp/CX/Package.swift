// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CX",
    platforms: [.iOS(.v14)], //플랫폼도 버전을 맞춰줘야 한다
    products: [
        .library(
            name: "AppHome",
            targets: ["AppHome"]
        ),
    ],
    dependencies: [
      .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.1"),
      .package(path: "../Finance"),
      .package(path: "../Transport"),
      .package(path: "../Platform")
    ],
    targets: [
        
        .target(
            name: "AppHome",
            dependencies: [
              "ModernRIBs",
              .product(name: "FinanceRepository", package: "Finance"),//🔥로컬 라이브러리 의존🔥
              .product(name: "TransportHome", package: "Transport"),//🔥로컬 라이브러리 의존🔥
              .product(name: "SuperUI", package: "Platform")//🔥로컬 라이브러리 의존🔥
            ]
        ),
    ]
)
