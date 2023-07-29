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
    .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.1"), //ModernRIBs
    .package(path: "../Platform")//이 패키지 자체에 추가해주는 의존성
    //로컬 패키지 같은 경우에는 로컬 경로로 지정해줄 수 있다 (🔥내가 아닌 패키지의 모듈은 여기에🔥)
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
