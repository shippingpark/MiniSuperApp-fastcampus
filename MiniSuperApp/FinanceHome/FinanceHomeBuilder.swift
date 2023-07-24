import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

//컴포넌트가 (자식에게 필요로한 정보) SuperPayDashboard를 confirm 하도록 채택
//컴포넌트 : 리불렛이 필요로 하는 정보들을 담는 객체 (자식 리불렛이 필요로 하는 것들 포함)
//자식들의 디펜던시를 부모 컴포넌트가 confirm 하도록 함
final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency {
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
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
    let component = FinanceHomeComponent(dependency: dependency)
    let viewController = FinanceHomeViewController()
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    //superPayDashboardBuilder를 생성하기 위해서는, 해당 리불렛이 동작하기 위해 필요로 하는 객체들을 주입해 준다
    let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
    
    //필요로 하는 정보를 다 생성했다면 (Builder의 역할)
    //해당 정보를 Router로 넘겨준다
    return FinanceHomeRouter(
      interactor: interactor,
      viewController: viewController,
      superPayDashboardBuildable:  superPayDashboardBuilder
    )
  }
}
