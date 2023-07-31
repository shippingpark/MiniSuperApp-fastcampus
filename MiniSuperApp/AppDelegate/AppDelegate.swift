import UIKit
import ModernRIBs

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
  var window: UIWindow?
  
  private var launchRouter: LaunchRouting?
  private var urlHandler: URLHandler?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    let result = AppRootBuilder(dependency: AppComponent()).build()
    self.launchRouter = result.launchRouter
    self.urlHandler = result.urlHandler
    launchRouter?.launch(from: window)//앱의 첫 리블렛에만 사용 (부모 리블렛이 없으므로 어테치할 게 없어서)
    
    return true
  }
}

protocol URLHandler: AnyObject {
  func handle(_ url: URL)
}
