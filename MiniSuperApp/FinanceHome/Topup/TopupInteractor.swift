//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs

protocol TopupRouting: Routing {
  func cleanupViews()
  func attachAddPaymentMehtod()
  func detachAddPaymentMehtod()
  func attachEnterAmount()
  func detachEnterAmount()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TopupListener: AnyObject {
    func topupDidClose()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {

  weak var router: TopupRouting?
  weak var listener: TopupListener?
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy//🍯
  
  private let dependency: TopupInteractorDependency
  
  init(
    dependency: TopupInteractorDependency
  ) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    self.dependency = dependency
    super.init()
    self.presentationDelegateProxy.delegate = self
  }

  override func didBecomeActive() {
      super.didBecomeActive()
    
    if dependency.cardOnFileRepository.cardOnFile.value.isEmpty {
      //카드 추가 화면
      router?.attachAddPaymentMehtod()
    } else {//카드가 있다면
      //금액 입력 확인
      router?.attachEnterAmount()
    }
  }

  override func willResignActive() {
      super.willResignActive()

      router?.cleanupViews()//부모가 detach Child할 때 불리게 됌. 뷰를 전부 지울 책임 
  }
  
  
  func presentationControllerDidDismiss() {
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMehtod() //라우터 상에서 삭제
    listener?.topupDidClose() //부모에게 삭제해 달라고 요청 (자식 라우터 해제 작업)🔥
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapClose() {
    router?.detachEnterAmount()//일단 해당 리블렛 디태치
    listener?.topupDidClose() //리스너에게 우리 끝났다고도 알려줌 (리스너가 topup(self) 디태치 할 수 있도록)
  }
}

// MARK: - 뷰가 있는 리블렛과 없는 리블렛의 차이
//1️⃣ 뷰가 있는 리블렛
//떠 있던 화면을 삭제시키는 건 부모의 역할
//2️⃣뷰가 없는 리블렛
//부모 리블렛이 present해 준 뷰가 없기 때문에 직접 dismiss 하지 않는다
//자신이 끝났을 때, 본인이 올린 화면을 본인이 직접 다 닫을 책임이 있다

