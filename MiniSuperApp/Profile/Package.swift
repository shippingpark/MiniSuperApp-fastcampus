// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Profile",
    platforms: [.iOS(.v14)], //플랫폼도 버전을 맞춰줘야 한다
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ProfileHome",
            targets: ["ProfileHome"]),
    ],
    dependencies: [
      .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.1"),
    ],
    targets: [

        .target(
            name: "ProfileHome",
            dependencies: [
              "ModernRIBs"
            ]),
    ]
)
