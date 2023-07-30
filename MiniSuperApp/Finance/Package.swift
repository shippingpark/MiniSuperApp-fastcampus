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
    
      .library(
        name: "Topup",
        targets: ["Topup"]),
    
      .library(
        name: "FinanceHome",
        targets: ["FinanceHome"]),
    
    .library( //새로운 라이브러리
      name: "FinanceEntity",
      targets: ["FinanceEntity"]),
    
    .library( //새로운 라이브러리 모듈
      name: "FinanceRepository",
      targets: ["FinanceRepository"])
    
  ],
  dependencies: [
    .package(url: "https://github.com/DevYeom/ModernRIBs.git", from: "1.0.1"), //ModernRIBs
    .package(path: "../Platform")//이 패키지 자체에 추가해주는 의존성
    //로컬 패키지 같은 경우에는 로컬 경로로 지정해줄 수 있다 (🔥내가 아닌 패키지의 모듈은 여기에🔥)
  ],
  targets: [
    .target(
      name: "AddPaymentMethod",
      dependencies: [
        "ModernRIBs",
        "FinanceEntity", //이 패키지 내에서 해당 라이브러리를 사용해야 하므로 디펜던시에 추가해준다
        "FinanceRepository",
        .product(name: "RIBsUtil", package: "Platform"),//🔥로컬 라이브러리 의존🔥
        .product(name: "SuperUI", package: "Platform")//🔥로컬 라이브러리 의존🔥
      ]
    ),
    
    .target(
      name: "Topup",
      dependencies: [
        "ModernRIBs",
        "FinanceEntity",
        "FinanceRepository",
        "AddPaymentMethod",
        .product(name: "RIBsUtil", package: "Platform"),//🔥로컬 라이브러리 의존🔥
        .product(name: "SuperUI", package: "Platform")//🔥로컬 라이브러리 의존🔥
      ]
    ),
    
      .target(
        name: "FinanceHome",
        dependencies: [
          "ModernRIBs",
          "FinanceEntity",
          "FinanceRepository",
          "AddPaymentMethod",
          "Topup",
          .product(name: "RIBsUtil", package: "Platform"),//🔥로컬 라이브러리 의존🔥
          .product(name: "SuperUI", package: "Platform")//🔥로컬 라이브러리 의존🔥
        ]
      ),
    
    .target(
      name: "FinanceEntity", //추가 이후에 이름으로 내부 모듈에 적용 가능
      dependencies: [
      ]
    ),
    .target(
      name: "FinanceRepository",
      dependencies: [
        "FinanceEntity", //🔥패키지 내부 라이브러리 의존🔥
        .product(name: "CombineUtil", package: "Platform")//🔥로컬 라이브러리 의존🔥
      ]
    )
  ]
)
