//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol EnterAmountListener: AnyObject {//부모 Interactor에게 요청할 부분
  func enterAmountDidTapClose()
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {
  

  weak var router: EnterAmountRouting?
  weak var listener: EnterAmountListener?

  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: EnterAmountPresentable) {
      super.init(presenter: presenter)
      presenter.listener = self
  }

  override func didBecomeActive() {
      super.didBecomeActive()
      // TODO: Implement business logic here.
  }

  override func willResignActive() {
      super.willResignActive()
      // TODO: Pause any business logic.
  }
  
  func didTapClose() {
    listener?.enterAmountDidTapClose()
  }
  
  func didTapPaymentMethod() {
    
  }
  
  func didTapTopup(with amount: Double) {
    
  }
}
