import UIKit
import ProfileHome
import ModernRIBs
import FinanceHome
import FinanceRepository
import AppHome

protocol AppRootDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

//AppRootCompoent 있던 자리 

// MARK: - Builder

protocol AppRootBuildable: Buildable {
  func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler)
}

final class AppRootBuilder: Builder<AppRootDependency>, AppRootBuildable {
  
  let tabBar = RootTabBarController()
  
  override init(dependency: AppRootDependency) {
    super.init(dependency: dependency)
  }
  
  func build() -> (launchRouter: LaunchRouting, urlHandler: URLHandler) {
    let component = AppRootComponent(
      dependency: dependency,
      cardOnFileRepository: CardOnFileRepositoryImp(),
      superPayRepository:  SuperPayRepositoryImp(),
      rootViewController: tabBar
    )
    
    let interactor = AppRootInteractor(presenter: tabBar)
  
    //자기(부모)가 필요한 세 개의 리불렛을 만들기 위해서 빌더를 만든다
    let appHome = AppHomeBuilder(dependency: component)
    let financeHome = FinanceHomeBuilder(dependency: component)
    let profileHome = ProfileHomeBuilder(dependency: component)
    
    //그걸 붙이는 건 라우터가 한다
    let router = AppRootRouter(
      interactor: interactor,
      viewController: tabBar,
      appHome: appHome,
      financeHome: financeHome,
      profileHome: profileHome
    )
    
    return (router, interactor)
  }
}
