import ModernRIBs

//Router를 이용한 자식 리블렛 연결 4️⃣: 자식 라우터를 생성하기 위해 넣어주는 파라미터로 자식의 리스너가 '나'임을 밝히기 위해
//'SuperPayDashboardListener' 채택
protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener  {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
  //위에 올릴 뷰
  func addDashboard(_ view: ViewControllable) //뷰컨트롤러블을 인자로 받는다
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {
  
  private let superPayDashboardBuildable: SuperPayDashboardBuildable
  //🚨1️⃣ 똑같은 자식을 두 번 이상 추가해 주지 않도록 방어 로직 추가
  private var superPayRouting: Routing? //자식 라우터를 붙인 뒤 프로퍼티로 들고 있게 만듬
  private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnFileRouting: Routing?
  

  //ViewController는 단순 View로 분류, 비즈니스 로직은 Interactor로 들어감
  init(
    interactor: FinanceHomeInteractable, //모든 로직의 시작점. Interactor
    viewController: FinanceHomeViewControllable,
    superPayDashboardBuildable: SuperPayDashboardBuildable,
    cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
  ) {
    self.superPayDashboardBuildable = superPayDashboardBuildable
    self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  //Router를 이용한 자식 리블렛 연결 3️⃣: Buildable(Builder)의 build() 메서드를 호출해서 Router를 받아줘야 한다
  func attachSuperPayDashboard() {
    //🚨2️⃣ Attach 하기 전에 검사
    if superPayRouting != nil {
      return //똑같은 뷰를 두 번 붙이지 않도록
    }
    
    //build를 해줄 때 리스너를 파라미터로 넘겨줘야 한다
    //자식 리블렛의 Listener는 비즈니스 로직을 담당하는 '나'의 Interactor
    let router = superPayDashboardBuildable.build(withListener: interactor)
    
    //Router를 이용한 자식 리블렛 연결 4️⃣: FinanceHomeViewController에서 프로토콜을 구현해야 할 차례
    //이 뷰컨은 present 할 게 아니고, subview로 넣을 것임
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    //Router를 이용한 자식 리블렛 연결 5️⃣-끝
    attachChild(router)
  }
  
  func attachCardOnFileDashboard() {
    if cardOnFileRouting != nil {
      return
    }
    let router = cardOnFileDashboardBuildable.build(withListener: interactor)
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    self.cardOnFileRouting = router
    attachChild(router)
  }
}



// MARK: - 부모가 자식을 연결하는 과정 상세

// Interactor
//1️⃣:
// - 내부 속성 router는 모듈Routing이라는 프로토콜 타입이다.
// - 원하는 리불렛 연결이 있을 시 해당 모듈Routing 프로토콜에 메서드를 선언해 줘야 한다

//2️⃣ :
// - 모듈Routing 프로토콜 내 원하는 메서드 구현
// - Interactor는 해당 메서드를 통해 라우터에게 리블렛 연결을 요청한다 (router?.붙여줘_자식_리블렛)

//Router
//3️⃣:
// - 생성자로 전달 받은 자식Builer를 내부 속성 프로토콜과 Buildable과 연결해 준다
// - 해당 Buildable을 통해 빌드()의 반환 값인 router를 받는다
// - 이때 , 두 가지를 고려한다
// - 붙여줘_자식_리블렛() 메서드는 Router가 채택한 Routing 메서드 내에 존재한다. 이 메서드 내에서 자식 Router를 생성한다

//4️⃣:
// - 모듈Listner란, 자식 모듈이 부모 모듈에게 접근하기 위한 델리게이트다.
// - 자식 모듈을 생성하고 Router에 붙여줄 계획이라면 자식 Router 생성 시 (Build) 메서드 파라미터로 Lisnter가 '나' 임을 밝혀 줘야 한다.
// - 모듈과 모듈간의 소통은 비즈니스 로직이라 보고 listner에는 '나' 즉 자식 모듈의 부모인 내 interactor를 넣어준다.
// - Router가 interactor를 전달하고 있음에 유의, interactor는 프로토콜 타입이다
// - interactor를 listner로서 자식에게 전달해야 하므로 interactable 프로토콜에 자식Lister 채택


// MARK: - 부모가 자식을 연결하는 과정 정리
//1️⃣(Interactor), Routing 프로토콜에 자식 모듈 추가 메서드 작성
//2️⃣(Interactor), 해당 메서드를 실행
//3️⃣(Router), 추가된 메서드 상세 구현 작성
//4️⃣(Router), 빌드 메서드 파라미터로 자기 자신의 interactor를 전달하기 위해
//5️⃣(Router), interactable 프로토콜에 자식 Listner 채택
