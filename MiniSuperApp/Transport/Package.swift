// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Transport",
  platforms: [.iOS(.v14)], //플랫폼도 버전을 맞춰줘야 한다
  products: [
    .library(
        name: "TransportHome",
        targets: ["TransportHome"]),
  ],
  
  dependencies: [
  ],
  
  targets: [
    .target(
        name: "TransportHome",
        dependencies: [
        ],
        resources: [ //🔥리소스 추가하는 법
          .process("Resources"),
        ]
    ),
  ]
)
