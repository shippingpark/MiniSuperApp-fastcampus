//
//  AddPaymentMethodInteractor.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/28.
//

import ModernRIBs
import Combine

protocol AddPaymentMethodRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddPaymentMethodPresentable: Presentable {
    var listener: AddPaymentMethodPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AddPaymentMethodListener: AnyObject {
  func addPaymentMethodDidTapClose()
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod)
}

protocol AddPaymentMethodInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable>, AddPaymentMethodInteractable, AddPaymentMethodPresentableListener {

  weak var router: AddPaymentMethodRouting?
  weak var listener: AddPaymentMethodListener?
  
  private let dependency: AddPaymentMethodInteractorDependency
  
  private var cancellables: Set<AnyCancellable>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
      presenter: AddPaymentMethodPresentable,
      dependency: AddPaymentMethodInteractorDependency
    ) {
      self.dependency = dependency
      self.cancellables = .init()
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
    listener?.addPaymentMethodDidTapClose()
  }
  
  //뷰컨에서 요청 받으면, 백엔드의 카드추가 API를 호출할 것 
  func didTapConfirm(with number: String, cvc: String, expiry: String) {
    let info = AddPaymentMethodInfo(number: number, cvc: cvc, expiration: expiry)
    dependency.cardOnFileRepository.addCard(info: info).sink(
      receiveCompletion: { _ in  },
      receiveValue: { [weak self] method in
        self?.listener?.addPaymentMethodDidAddCard(paymentMethod: method) //부모인 FinanceHomeIneractor에게 알리는 중
      }
    ).store(in: &cancellables)
  }
}
