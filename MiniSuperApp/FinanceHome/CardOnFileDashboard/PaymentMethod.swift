//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/25.
//

import Foundation

//백엔드에서 받는 모델이라는 가정 (Dto?)
//이것만 가지고는 바로 화면에 뷰를 그려줄 수 없음
struct PaymentMethod: Decodable {
  let id: String
  let name: String
  let digits: String //카드 마지막 뒷 자리 4개
  let color: String
  let isPrimary: Bool //주 카드인 지
}

