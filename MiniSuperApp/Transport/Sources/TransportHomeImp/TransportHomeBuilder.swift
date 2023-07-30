
import ModernRIBs
import Topup
import FinanceRepository
import CombineUtil
import TransportHome

public protocol TransportHomeDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
}

final class TransportHomeComponent: Component<TransportHomeDependency>, TransportHomeInteractorDependency, TopupDependency {
  let topupBaseViewController: ModernRIBs.ViewControllable
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }//부모로부터 받는 값
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }//부모로부터 받는 값
  var superPayBalance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }
  
  
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
    
    let topupBuilder = TopupBuilder(dependency: component)
    
    return TransportHomeRouter(
      interactor: interactor,
      viewController: viewController,
      topupBuildable: topupBuilder
    )
  }
}
