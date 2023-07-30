//
//  File.swift
//  
//
//  Created by 박혜운 on 2023/07/30.
//

import UIKit
import FinanceEntity

//인터렉터와 뷰컨트롤러 간에만 필요
//데이터 모델이 아님
//따라서 각각의 모듈에 중복 배치해 주기로 함

struct PaymentMethodViewModel {
  let name: String
  let digits: String
  let color: UIColor
  
  init(_ paymentMethod: PaymentMethod) {
    name = paymentMethod.name
    digits = "**** \(paymentMethod.digits)"
    color = UIColor(hex: paymentMethod.color) ?? .systemGray //변환이 실패했을 경우 반환할
  }
}
