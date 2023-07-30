//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs
import AddPaymentMethod
import SuperUI
import RIBsUtil
import FinanceEntity
import Topup

protocol TopupInteractable: Interactable, AddPaymentMethodListener, EnterAmountListener, CardOnFileListener {
  var router: TopupRouting? { get set }
  var listener: TopupListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
  
  private var navigationControllable: NavigationControllerable?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  private let enterAmountBuildable: EnterAmountBuildable
  private var enterAmountRouting: Routing?
  
  private let cardOnFileBuildable: CardOnFileBuildable
  private var cardOnFileRouting: Routing?

    // TODO: Constructor inject child builder protocols to allow building children.
  init(interactor: TopupInteractable,
       viewController: ViewControllable,
       addPaymentMethodBuildable: AddPaymentMethodBuildable,
       enterAmountBuildable: EnterAmountBuildable,
       cardOnFileBuildable: CardOnFileBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.enterAmountBuildable = enterAmountBuildable
    self.cardOnFileBuildable = cardOnFileBuildable
    super.init(interactor: interactor)
    interactor.router = self
  }

    func cleanupViews() { //topupInteractor의 willResignActive에서 불린다 
      //부모가 나를 detach할 때 interactor에 의해 실행될 것임
      //이 기회에 topupRouter가 띄워줬던 모든 화면을 내려야 함
      // 뷰가 존재하고, 네비게이션도 존재한다면
      if viewController.uiviewController.presentedViewController != nil, navigationControllable != nil {
        navigationControllable?.dismiss(completion: nil)//topupRouter의 책임으로, 네비게이션도 없앰
      }
    }
  
  func attachAddPaymentMehtod(closeButtonType: DismissButtonType) {
    if addPaymentMethodRouting != nil {
      return
    }
    
    let router = addPaymentMethodBuildable.build(withListener: interactor, closeButtonType: closeButtonType)
    
    if let navigationControllable = navigationControllable {
      navigationControllable.pushViewController(router.viewControllable, animated: true)
    } else {
      presentInsideNavigation(router.viewControllable)
    }
    //(navigationcontroller에 싸서 보내야 함. 그래야 뒤로 닫기 버튼 같은 것을 활용할 수 있기 때문에
    attachChild(router)
    addPaymentMethodRouting = router
  }
  
  func detachAddPaymentMehtod() {
    guard let router = addPaymentMethodRouting else {
      return
    }
    
    //dismissPresentedNavigation(completion: nil)
    navigationControllable?.popViewController(animated: true)
    detachChild(router)
    addPaymentMethodRouting = nil 
  }
  
  func attachEnterAmount() { //두가지 어태치가 존재. 1️⃣카드가 존재해서 최초 present할 때 호출, 2️⃣카드 추가 후 호출
    if enterAmountRouting != nil {
      return
    }
    
    let router = enterAmountBuildable.build(withListener: interactor)
    if let navigation = navigationControllable {
      navigation.setViewControllers([router.viewControllable]) //한 번 날려준다
      resetChildRouting() //기존의 child를 다 지우고
    } else {
      presentInsideNavigation(router.viewControllable)
    }
    
    attachChild(router) //붙인다
    enterAmountRouting = router
  }
  
  func detachEnterAmount() {
    guard let router = enterAmountRouting else {
      return
    }
    
    dismissPresentedNavigation(completion: nil)
    detachChild(router)
    enterAmountRouting = nil
  }
  
  func attachCardOnFile(paymentMethods: [PaymentMethod]) {
    if cardOnFileRouting != nil {
      return
    }
    
    let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods) //🔥생성하기 위해 넣어줘야 할 값은 build 메서드 호출 시점에 파라미터로 전달해주면 된다
    navigationControllable?.pushViewController(router.viewControllable, animated: true)
    cardOnFileRouting = router
    attachChild(router)
  }
  
  func detachCardOnFile() {
    guard let router = cardOnFileRouting else {
      return
    }
    
    navigationControllable?.popViewController(animated: true)
    detachChild(router)
    cardOnFileRouting = nil
  }
  
  func popToRoot() {
    navigationControllable?.popToRoot(animated: true)
    resetChildRouting()
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
  
  private func resetChildRouting() {
    if let cardOnFileRouting = cardOnFileRouting {
      detachChild(cardOnFileRouting)
      self.cardOnFileRouting = nil
    }
    
    if let addPaymentMethodRouting = addPaymentMethodRouting {
      detachChild(addPaymentMethodRouting)
      self.addPaymentMethodRouting = nil
    }
  }
  

    // MARK: - Private

    private let viewController: ViewControllable
}
