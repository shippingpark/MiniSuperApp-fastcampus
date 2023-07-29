//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs

protocol TopupInteractable: Interactable, AddPaymentMethodListener {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
  
  private var navigationControllable: NavigationControllerable?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?

    // TODO: Constructor inject child builder protocols to allow building children.
  init(interactor: TopupInteractable,
       viewController: ViewControllable,
       addPaymentMethodBuildable: AddPaymentMethodBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    super.init(interactor: interactor)
    interactor.router = self
  }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }
  
  func attachAddPaymentMehtod() {
    if addPaymentMethodRouting != nil {
      return
    }
    
    let router = addPaymentMethodBuildable.build(withListener: interactor)
    //(navigationcontroller에 싸서 보내야 함. 그래야 뒤로 닫기 버튼 같은 것을 활용할 수 있기 때문에
    presentInsideNavigation(router.viewControllable)
    attachChild(router)
    addPaymentMethodRouting = router
  }
  
  func detachAddPaymentMehtod() {
    guard let router = addPaymentMethodRouting else {
      return
    }
    
    dismissPresentedNavigation(completion: nil)
    detachChild(router)
    addPaymentMethodRouting = nil 
  }
  
  //네비게이션으로 화면을 띄우는 헬퍼 메소드
  private func presentInsideNavigation(_ viewControllable: ViewControllable) {
    let navigation = NavigationControllerable(root: viewControllable)  //뷰를 띄울 때는 부모가 보내준 뷰
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    self.navigationControllable = navigation// push와 pop을 할 때 필요하므로 네비게이션을 프로퍼티로
    viewController.present(navigation, animated: true, completion: nil)
  }
  
  private func dismissPresentedNavigation(completion: (() -> Void)?) {
    if self.navigationControllable == nil {
      return
    }
    
    viewController.dismiss(completion: nil) //내가 직접 dismiss
    self.navigationControllable = nil
  }
  

    // MARK: - Private

    private let viewController: ViewControllable
}
