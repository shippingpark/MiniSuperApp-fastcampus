//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs

protocol TopupRouting: Routing {
  func cleanupViews()
  func attachAddPaymentMehtod(closeButtonType: DismissButtonType)
  func detachAddPaymentMehtod()
  func attachEnterAmount()
  func detachEnterAmount()
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func detachCardOnFile()
  func popToRoot()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TopupListener: AnyObject {
    func topupDidClose()
  func topupDidFinish()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get } //값을 직접 쓰기 때문에 readOnly ❌
}

final class TopupInteractor: Interactor, TopupInteractable, AddPaymentMethodListener, AdaptivePresentationControllerDelegate {

  weak var router: TopupRouting?
  weak var listener: TopupListener?
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy //🍯
  
  private var isEnterAmountRoot: Bool = false //🔥카드가 없어 추가하기 된 화면인지, 카드 추가하기 버튼을 눌러 들어온 추가하기 화면인 지 확인할 필요가 생김. 추가하기 버튼을 누르면 화면이 이동해야하는데, 추가하기 버튼으로 들어온 상태에선 카드 정보 화면이 이미 존재하여 pop, 뒤로 나가야 하기 때문임
  
  private var paymentMethods: [PaymentMethod] { //🍯 간결하게 표현하기 위한
    dependency.cardOnFileRepository.cardOnFile.value
  }
  
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
    
    if let card = dependency.cardOnFileRepository.cardOnFile.value.first { //카드가 있다면
      //금액 입력 확인
      isEnterAmountRoot = true
      dependency.paymentMethodStream.send(card) //스트림에 첫번째 카드 값을 보냄 //여기서 흘린 스트림을 EnterAmount가 읽어서 화면에 표시해야 함
      router?.attachEnterAmount()
    } else {//카드 추가 화면
      isEnterAmountRoot = false
      router?.attachAddPaymentMehtod(closeButtonType: .close) //🔥상황에 따른 백버튼 구분 
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
    if isEnterAmountRoot == false {
      //부모에게 삭제해 달라고 요청 (자식 라우터 해제 작업)🔥
      listener?.topupDidClose() //전체를 닫아주기
    }
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    dependency.paymentMethodStream.send(paymentMethod)
    if isEnterAmountRoot { //amount화면으로 들어왔다면
      router?.popToRoot()
    } else {
      isEnterAmountRoot = true
      router?.attachEnterAmount()
      
    }
  }
  
  func enterAmountDidTapClose() {
    router?.detachEnterAmount()//일단 해당 리블렛 디태치
    listener?.topupDidClose() //리스너에게 우리 끝났다고도 알려줌 (리스너가 topup(self) 디태치 할 수 있도록)
  }
  
  func enterAmountDidTapPaymentMethod() { //🍯이렇게 너무 길어질 때는 computedProperty를 선언함으로 간결하게 작성할 수 있음
//    router?.attachCardOnFile(paumentMethods: self.dependency.cardOnFileRepository.cardOnFile.value) //이때 PaymentMethodArray를 넘겨주면 딱 좋을 것 같음
    router?.attachCardOnFile(paymentMethods: paymentMethods)
    
  }
  
  func enterAmountDidFinsihTopup() {//충전이 완료
    listener?.topupDidFinish()
  }
  
  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }
  
  func cardOnFileDidTapAddCard() {
    router?.attachAddPaymentMehtod(closeButtonType: .back) //🔥상황에 따른 백버튼 구분
  }
  
  func cardOnFileDidSelect(at index: Int) {
    if let selected = paymentMethods[safe: index] { //🍯Array Extesion, index에 잘 못 접근하는 일을 원천 차단하고자
      dependency.paymentMethodStream.send(selected)
    } //카드를 선택하고 나면
    router?.detachCardOnFile()
  }
}

// MARK: - 뷰가 있는 리블렛과 없는 리블렛의 차이
//1️⃣ 뷰가 있는 리블렛
//떠 있던 화면을 삭제시키는 건 부모의 역할
//2️⃣뷰가 없는 리블렛
//부모 리블렛이 present해 준 뷰가 없기 때문에 직접 dismiss 하지 않는다
//자신이 끝났을 때, 본인이 올린 화면을 본인이 직접 다 닫을 책임이 있다



// MARK: - 카드 선택화면에서, 카드 종류 화면과 카드 선택화면은 서로를 몰라야 한다
//따라서 데이터 값을 가져오는 것은 부모인 Topup 리블렛이 수행하는 것이 옳다

