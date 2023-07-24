import UIKit
import ModernRIBs

protocol AppRootPresentableListener: AnyObject {
  
}

final class RootTabBarController: UITabBarController, AppRootViewControllable, AppRootPresentable { //탭바 컨트롤러를 상속받았음
  weak var listener: AppRootPresentableListener?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tabBar.isTranslucent = false
    tabBar.tintColor = .black
    tabBar.backgroundColor = .white
  }
  
  func setViewControllers(_ viewControllers: [ViewControllable]) { //세 개의 자식 리불렛을 뷰 컨트롤러의 탭바로 표시하고 있음
    super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
  }
}
