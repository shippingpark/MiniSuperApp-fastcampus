import ModernRIBs
import TransportHome
import FinanceRepository

public protocol AppHomeDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
}

final class AppHomeComponent: Component<AppHomeDependency>, TransportHomeDependency {
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  
}

// MARK: - Builder

public protocol AppHomeBuildable: Buildable {
  func build(withListener listener: AppHomeListener) -> ViewableRouting
}

public final class AppHomeBuilder: Builder<AppHomeDependency>, AppHomeBuildable { //AppHome 리불렛 객체들을 생성
  
  public override init(dependency: AppHomeDependency) { //디펜던시 인자로 받는 생성자
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: AppHomeListener) -> ViewableRouting { //리스너를 인자로 받는 메서드, 리블렛에 필요한 객체들을 생성
    let component = AppHomeComponent(dependency: dependency)//리블렛에 필요한 객체들을 담고 있을 바구니
    let viewController = AppHomeViewController()
    let interactor = AppHomeInteractor(presenter: viewController)// 비즈니스 로직이 들어가는 리블렛의 두뇌
    interactor.listener = listener
    
    let transportHomeBuilder = TransportHomeBuilder(dependency: component)
    
    //리턴 된 라우터는 부모 리블렛이 사용함
    //1) 앱 홈의 부모인 앱 루트에 가보면
    return AppHomeRouter( //리블렛 간의 이동을 담당 (자식 리블렛을 뗐다 붙였다)
      interactor: interactor,
      viewController: viewController,
      transportHomeBuildable: transportHomeBuilder
    )
  }
}
