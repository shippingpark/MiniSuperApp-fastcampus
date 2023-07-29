//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs

//topup 리불렛을 이용하여 view를 띄울 때, topup리불렛이 뷰컨을 소유하고 있는 것이 아니라, 부모가 지정해준 뷰컨을 사용하게 됨 

protocol TopupDependency: Dependency { //부모 리불렛이 viewcontroller를 하나 지정해줘야함
  var topupBaseViewController: ViewControllable { get }
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
}

final class TopupComponent: Component<TopupDependency>, TopupInteractorDependency, AddPaymentMethodDependency, EnterAmountDependency, CardOnFileDependency {

  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  fileprivate var TopupViewController: ViewControllable { dependency.topupBaseViewController }

  let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  
  init(
    dependency: TopupDependency,
    paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  ) {
    self.paymentMethodStream = paymentMethodStream
    super.init(dependency: dependency)
  }

  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {

  override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }

  func build(withListener listener: TopupListener) -> TopupRouting {
    let paymentMethodStream = CurrentValuePublisher(PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false))//💦최초 값이 필요하므로 어쩔 수 없이 더미 값을 생성
    //여기에 직접 값을 쓸 이는 topupInteractor
    
    let component = TopupComponent(dependency: dependency, paymentMethodStream: paymentMethodStream)
      let interactor = TopupInteractor(dependency: component)
      interactor.listener = listener
    
    let addPaymentMethodBuilder = AddPaymentMethodBuilder(dependency: component)
    let enterAmountBuilder = EnterAmountBuilder(dependency: component)
    let cardOnFileBuildable = CardOnFileBuilder(dependency: component)
    
      return TopupRouter(
        interactor: interactor,
        viewController: component.TopupViewController,
        addPaymentMethodBuildable: addPaymentMethodBuilder,
        enterAmountBuildable: enterAmountBuilder,
        cardOnFileBuildable: cardOnFileBuildable
        )
  }
}
