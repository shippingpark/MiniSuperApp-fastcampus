import ModernRIBs
import UIKit

protocol FinanceHomePresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class FinanceHomeViewController: UIViewController, FinanceHomePresentable, FinanceHomeViewControllable {
  
  
  //StackView 존재, StackView 안에 들어갈 View들을 자식 리불렛으로부터
  
  weak var listener: FinanceHomePresentableListener?
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.spacing = 4
    return stackView
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
  }
  
  func setupViews() {
    title = "슈퍼페이"
    tabBarItem = UITabBarItem(title: "슈퍼페이", image: UIImage(systemName: "creditcard"), selectedImage: UIImage(systemName: "creditcard.fill"))
    view.backgroundColor = .white
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
      //stackView에 View를 붙이려면 자식 리불렛이 필요하다 (라우터의 역할)
      //자식 리불렛을 생성하려면 해당 빌더가 필요하다 (빌더의 역할)
      //
    ])
  }
  
  //Router를 이용한 자식 리블렛 연결 5️⃣: FinanceHomeViewControllable 델리게이트 통해 전달 받은 뷰컨을 화면 위에 올림
  func addDashboard(_ view: ViewControllable) {
    let vc = view.uiviewController
    
    addChild(vc)//ChildViewController로 추가
    stackView.addArrangedSubview(vc.view) //stackView에 뷰컨.뷰 추가
    vc.didMove(toParent: self) //⭐️(몰랐던 정보) 뷰컨트롤러 라이프 사이클을 유지하기 위함
    //Router에서 이제 attachChild 할 준비 완료
  }
}
