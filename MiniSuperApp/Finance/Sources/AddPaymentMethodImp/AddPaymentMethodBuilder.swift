//
//  AddPaymentMethodBuilder.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/28.
//

import ModernRIBs
import FinanceRepository
import RIBsUtil
import AddPaymentMethod

public protocol AddPaymentMethodDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodComponent: Component<AddPaymentMethodDependency>, AddPaymentMethodInteractorDependency {
  //이 리포지토리는 부모에게서부터 받아오겠음
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
}

// MARK: - Builder

//public protocol AddPaymentMethodBuildable: Buildable {
//    func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting
//}
//까다로운 문제💦 프로토콜이 Public이므로 AddPaymentMethodRouting 프로토콜도 Public이어야 함
//그러나 AddPaymentMethodRouting에는 아무런 메서드가 없음
//그래서 AddPaymentMethodRouting 자체를 없애고 리턴 타입을 ViewableRouting로 바꾸어 줌

public final class AddPaymentMethodBuilder: Builder<AddPaymentMethodDependency>, AddPaymentMethodBuildable {

  public override init(dependency: AddPaymentMethodDependency) {
        super.init(dependency: dependency)
    }

  public func build(withListener listener: AddPaymentMethodListener, closeButtonType: DismissButtonType) -> ViewableRouting {
        let component = AddPaymentMethodComponent(dependency: dependency)
      let viewController = AddPaymentMethodViewController(closerButtonType: closeButtonType)
        let interactor = AddPaymentMethodInteractor(
          presenter: viewController,
          dependency: component
        )
        interactor.listener = listener
        return AddPaymentMethodRouter(interactor: interactor, viewController: viewController)
    }
}
