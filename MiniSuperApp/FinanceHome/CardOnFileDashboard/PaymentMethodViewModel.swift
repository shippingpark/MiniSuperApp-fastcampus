//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/25.
//

import UIKit
import FinanceEntity

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
