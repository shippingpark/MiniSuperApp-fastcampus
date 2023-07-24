import ModernRIBs

protocol AppRootInteractable: Interactable,
                              AppHomeListener,
                              FinanceHomeListener,
                              ProfileHomeListener {
  var router: AppRootRouting? { get set }
  var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
  func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
  
  private let appHome: AppHomeBuildable
  private let financeHome: FinanceHomeBuildable
  private let profileHome: ProfileHomeBuildable
  
  private var appHomeRouting: ViewableRouting?
  private var financeHomeRouting: ViewableRouting?
  private var profileHomeRouting: ViewableRouting?
  
  init(
    interactor: AppRootInteractable,
    viewController: AppRootViewControllable,
    appHome: AppHomeBuildable,
    financeHome: FinanceHomeBuildable,
    profileHome: ProfileHomeBuildable
  ) {
    self.appHome = appHome
    self.financeHome = financeHome
    self.profileHome = profileHome
    
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachTabs() { //자식 빌더의 빌드 메서드들을 호출해서 router를 받는다
    let appHomeRouting = appHome.build(withListener: interactor)
    let financeHomeRouting = financeHome.build(withListener: interactor)
    let profileHomeRouting = profileHome.build(withListener: interactor)
    
    //1) attachChild를 호출해 준다 (각 리블렛들의 레퍼런스를 유지하고, 인터렉터의 라이프 사이클 관련 메서드를 호출하는 작업)
    attachChild(appHomeRouting)
    attachChild(financeHomeRouting)
    attachChild(profileHomeRouting)
    
    //2) 뷰컨트롤러를 띄우는 작업
    let viewControllers = [
      NavigationControllerable(root: appHomeRouting.viewControllable), //viewControllable 은 UIViewController를 한 번 감싼 것, 보통 라우터에는 import UIKit이 없기 때문
      //UINavigationController를 숨기기위한 객체 NavigationControllerable
      NavigationControllerable(root: financeHomeRouting.viewControllable),
      profileHomeRouting.viewControllable
    ]
    
    viewController.setViewControllers(viewControllers)
  }
}
