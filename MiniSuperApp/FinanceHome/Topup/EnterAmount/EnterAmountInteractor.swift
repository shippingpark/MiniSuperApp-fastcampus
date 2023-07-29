//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs
import Combine

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
    var listener: EnterAmountPresentableListener? { get set }
    func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol EnterAmountListener: AnyObject {//부모 Interactor에게 요청할 부분
  func enterAmountDidTapClose()
  func enterAmountDidTapPaymentMethod()
}

protocol EnterAmountInteractorDependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
}

final class EnterAmountInteractor: PresentableInteractor<EnterAmountPresentable>, EnterAmountInteractable, EnterAmountPresentableListener {
  

  weak var router: EnterAmountRouting?
  weak var listener: EnterAmountListener?

  private let dependency: EnterAmountInteractorDependency
  
  private var cancellables: Set<AnyCancellable>
  
  // in constructor.
  init(
    presenter: EnterAmountPresentable,
    dependency: EnterAmountInteractorDependency
  ) {
    self.dependency = dependency
    self.cancellables = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }

  override func didBecomeActive() {
      super.didBecomeActive()
      
    dependency.selectedPaymentMethod.sink { [weak self] paymentMethod in //구독
      self?.presenter.updateSelectedPaymentMethod(with: SelectedPaymentMethodViewModel(paymentMethod))
    }.store(in: &cancellables)
  }

  override func willResignActive() {
      super.willResignActive()
      // TODO: Pause any business logic.
  }
  
  func didTapClose() {
    listener?.enterAmountDidTapClose()
  }
  
  func didTapPaymentMethod() {
    listener?.enterAmountDidTapPaymentMethod()
  }
  
  func didTapTopup(with amount: Double) {
    
  }
}
