import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get } //부모에게 주입 받자
  var superPayRepository: SuperPayRepository { get }
}

//컴포넌트가 (자식에게 필요로한 정보) SuperPayDashboard를 confirm 하도록 채택
//컴포넌트 : 리불렛이 필요로 하는 정보들을 담는 객체 (자식 리불렛이 필요로 하는 것들 포함)
//자식들의 디펜던시를 부모 컴포넌트가 confirm 하도록 함
//🍯 타입 캐스팅을 통한 자식 리블렛 데이터 접근 제한 
final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency, AddPaymentMethodDependency, TopupDependency {
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance } //자식에게는 ReadOnly
  var topupBaseViewController: ViewControllable
  
  init(
    dependency: FinanceHomeDependency,
    topupBaseViewController: ViewControllable
  ) {
    self.topupBaseViewController = topupBaseViewController
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

//Builder는 Buildable이라는 인터페이스를 받고 있다
//라우터에서는 Buildable 프로토콜 타입으로 받는다
final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
    //Finance는 금융 관련 기능의 첫 시작이므로 여기서 balance(잔여 금액) 시작하는 게 좋아 보임
    let balancePublisher = CurrentValuePublisher<Double>(10000)
    let viewController = FinanceHomeViewController()
    
    let component = FinanceHomeComponent(
      dependency: dependency,
      topupBaseViewController: viewController//자식에게 내 뷰컨을 넘겨줌 
    )
    
    
    let interactor = FinanceHomeInteractor(presenter: viewController)//FinanceHomeViewController의 listner는 interactor 라고 밝혀주기 위해, interactor에 viewcontroller를 넣고 interector는 네 listner가 '나'다 라는 작업을 수행함
    interactor.listener = listener
    
    //superPayDashboardBuilder를 생성하기 위해서는, 해당 리불렛이 동작하기 위해 필요로 하는 객체들을 주입해 준다
    let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
    let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
    let addPaymentMethodHomeBuilder = AddPaymentMethodBuilder(dependency: component)
    let topupBuilder = TopupBuilder(dependency: component)
    
    //필요로 하는 정보를 다 생성했다면 (Builder의 역할)
    //해당 정보를 Router로 넘겨준다
    return FinanceHomeRouter(
      interactor: interactor,
      viewController: viewController,
      superPayDashboardBuildable:  superPayDashboardBuilder,
      cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
      addPaymentMethodBuildable: addPaymentMethodHomeBuilder,
      topupBuildable: topupBuilder
    )
  }
}
