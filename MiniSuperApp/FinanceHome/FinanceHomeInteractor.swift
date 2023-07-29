import ModernRIBs

protocol FinanceHomeRouting: ViewableRouting {
  func attachSuperPayDashboard() //Router를 이용한 자식 리블렛 연결 2️⃣ : Routing 프로토콜 내 메서드 구현
  //Interactor는 라우팅 이라는 프로토콜로 라우터에 접근한다
  func attachCardOnFileDashboard()
  func attachAddPaymentMethod()
  func detachAddPaymentMethod()
  func attachTopup()
  func detachTopup()
}

protocol FinanceHomePresentable: Presentable {
  var listener: FinanceHomePresentableListener? { get set }
}

protocol FinanceHomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener, AdaptivePresentationControllerDelegate {
  
  
  weak var router: FinanceHomeRouting?
  weak var listener: FinanceHomeListener?
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy//🍯
  
  override init(presenter: FinanceHomePresentable) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init(presenter: presenter)
    presenter.listener = self
    self.presentationDelegateProxy.delegate = self
  }
  
  //여기서 SuperPayDashboard 리블렛을 붙여주면 된다. 내(FinanceHomeVC) 가 ViewDidLoad 된 뒤 호출되는 장소이다
  //리블렛은 붙이려면, Router에게 일을 시켜야 함
  override func didBecomeActive() {
    super.didBecomeActive()
    //Router를 이용한 자식 리블렛 연결 1️⃣: outer는 FinanceHomeRouting이라는 프로토콜로 구성되어 있으므로 원하는 이동이 있을 시 해당 프토콜에 메서드를 선언해 줘야 한다
    router?.attachSuperPayDashboard()
    router?.attachCardOnFileDashboard()
  }
  
  override func willResignActive() {
    super.willResignActive()
  }
  
  func presentationControllerDidDismiss() {
    router?.detachAddPaymentMethod()
  }
  
  // MARK: - CardOnFileDashboardLisnter
  func cardOnFileDashboardDidTapAddPaymentMethod() { //자식 Interactor에서 받은 연락. router로 이동
    router?.attachAddPaymentMethod()
  }
  
  // MARK: - AddPaymentMethodLisnter
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    router?.detachAddPaymentMethod()
  }
  
  func superPayDashboardDidTopup() {
    router?.attachTopup()
  }
  
  func topupDidClose() {
    router?.detachTopup()
  }
  
  func topupDidFinish() {
    router?.detachTopup()
  }
}
