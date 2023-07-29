//
//  EnterAmountInteractor.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs
import Combine
import Foundation

protocol EnterAmountRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EnterAmountPresentable: Presentable {
  var listener: EnterAmountPresentableListener? { get set }
  func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel)
  func startLoading()
  func stopLoading()
  
}

protocol EnterAmountListener: AnyObject {//부모 Interactor에게 요청할 부분
  func enterAmountDidTapClose()
  func enterAmountDidTapPaymentMethod()
  func enterAmountDidFinsihTopup()
}

protocol EnterAmountInteractorDependency {
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { get }
  var superPayRepository: SuperPayRepository { get }
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
    //여기서 API 호출
    presenter.startLoading()
    
    dependency.superPayRepository.topup( //🔥superPayRepository는 백그라운드에서 실행
      amount: amount,
      paymentMethodID: dependency.selectedPaymentMethod.value.id
    )
    .receive(on: DispatchQueue.main)//🔥그러니 받기 전에 한 번 receive해줘야 함
    .sink(
      receiveCompletion: { [weak self] _ in
        self?.presenter.stopLoading()//🔥그러나 UI는 메인에서
      },
      receiveValue: { [weak self] in
        self?.listener?.enterAmountDidFinsihTopup()//🔥그러나 UI는 메인에서 실행되길 바람
      }
    ).store(in: &cancellables)
  }
}

// MARK: - 잔액 충전 API를 여기서 호출

