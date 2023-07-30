//
//  File.swift
//  
//
//  Created by 박혜운 on 2023/07/30.
//

import ModernRIBs
import FinanceEntity
import RIBsUtil

public protocol AddPaymentMethodBuildable: Buildable {
    func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting
}

public protocol AddPaymentMethodListener: AnyObject { //리블렛에 필요한 것들을 public으로 이 리블렛을 사용하는 모듈들에게 노출해야함
  func addPaymentMethodDidTapClose()
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) //🔥외부 속성
}
