
import ModernRIBs
import Topup
import FinanceRepository
import CombineUtil
import TransportHome

public protocol TransportHomeDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
  var topupBuildable: TopupBuildable { get } //여기서 빌더블을 주입 받겠음
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency { //이 의존성!! 직접 참조하고 있던 (뭐 넣어야 하는 지 알아야하는) 몰라야 의존 방향이 역전됨
  let topupBaseViewController: ModernRIBs.ViewControllable
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }//부모로부터 받는 값
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }//부모로부터 받는 값
  var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
  var topupBuildable: TopupBuildable { dependency.topupBuildable } //부모로부터 받은 것
  
  
  init(
    dependency: TransportHomeDependency,
    topupBaseViewController: ViewControllable
  ) {
    self.topupBaseViewController = topupBaseViewController
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

public final class TransportHomeBuilder: Builder<TransportHomeDependency>, TransportHomeBuildable {
  
  public override init(dependency: TransportHomeDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: TransportHomeListener) -> ViewableRouting {
    
    let viewController = TransportHomeViewController()
    let component = TransportHomeComponent(dependency: dependency, topupBaseViewController: viewController)
    
    
    let interactor = TransportHomeInteractor(presenter: viewController, dependency: component)
    interactor.listener = listener
    
    //let topupBuilder = TopupBuilder(dependency: component)//여길! 끊어내야함
    
    return TransportHomeRouter(
      interactor: interactor,
      viewController: viewController,
      topupBuildable: component.topupBuildable//컴포넌트에서 꺼내서
    )
  }
}
