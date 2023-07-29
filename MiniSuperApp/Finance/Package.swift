// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Finance",
  platforms: [.iOS(.v14)], //플랫폼도 버전을 맞춰줘야 한다
  products: [
    .library(
      name: "AddPaymentMethod",
      targets: ["AddPaymentMethod"]),
  ],
  dependencies: [
    .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.1") //ModernRIBs
  ],
  targets: [
      // Targets are the basic building blocks of a package. A target can define a module or a test suite.
      // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "AddPaymentMethod",
      dependencies: [
        "ModernRIBs"
      ]
    ),
  ]
)
