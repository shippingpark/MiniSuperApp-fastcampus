import ModernRIBs

protocol FinanceHomeRouting: ViewableRouting {
  func attachSuperPayDashboard() //Router를 이용한 자식 리블렛 연결 2️⃣ : Routing 프로토콜 내 메서드 구현
  //Interactor는 라우팅 이라는 프로토콜로 라우터에 접근한다
  
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FinanceHomePresentable: Presentable {
  var listener: FinanceHomePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener {
  
  weak var router: FinanceHomeRouting?
  weak var listener: FinanceHomeListener?
  
  // TODO: Add additional dependencies to constructor. Do not perform any logic
  // in constructor.
  override init(presenter: FinanceHomePresentable) {
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  //여기서 SuperPayDashboard 리블렛을 붙여주면 된다. 내(FinanceHomeVC) 가 ViewDidLoad 된 뒤 호출되는 장소이다
  //리블렛은 붙이려면, Router에게 일을 시켜야 함
  override func didBecomeActive() {
    super.didBecomeActive()
    //Router를 이용한 자식 리블렛 연결 1️⃣: outer는 FinanceHomeRouting이라는 프로토콜로 구성되어 있으므로 원하는 이동이 있을 시 해당 프토콜에 메서드를 선언해 줘야 한다
    router?.attachSuperPayDashboard()
    
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}
