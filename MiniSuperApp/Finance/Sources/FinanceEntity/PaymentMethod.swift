//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/25.
//

import Foundation

//백엔드에서 받는 모델이라는 가정 (Dto?)
//이것만 가지고는 바로 화면에 뷰를 그려줄 수 없음
public struct PaymentMethod: Decodable {
  public let id: String
  public let name: String
  public let digits: String //카드 마지막 뒷 자리 4개
  public let color: String
  public let isPrimary: Bool //주 카드인 지
  
  //🔥public 으로 만들면 기본 이니셜 라이져가 사라짐
  public init(id: String, name: String, digits: String, color: String, isPrimary: Bool) {
    self.id = id
    self.name = name
    self.digits = digits
    self.color = color
    self.isPrimary = isPrimary
  }
  
}

