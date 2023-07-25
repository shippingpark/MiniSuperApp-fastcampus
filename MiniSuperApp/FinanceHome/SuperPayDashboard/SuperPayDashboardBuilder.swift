//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/24.
//

import ModernRIBs
import Foundation

//부모로 부터 받고 싶은 것은 여기에 선언
protocol SuperPayDashboardDependency: Dependency {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

//컴포넌트는 본인과 자식 리블렛이 필요로 하는 객체들을 담고 있는 바구니 이므로, superPayDashboardDependency 또한 채택한다
final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>, SuperPayDashboardInteractorDependency {
  //SuperPayDashboardInteractorDependency 필수 구현자
  var balance: ReadOnlyCurrentValuePublisher<Double> { dependency.balance } //부모로 부터 받아온 디펜던시를 연결해 주는 역할만 수행
  var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
  func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}


final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable {

  override init(dependency: SuperPayDashboardDependency) {
      super.init(dependency: dependency)
  }

  func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
    let component = SuperPayDashboardComponent(dependency: dependency)
    let viewController = SuperPayDashboardViewController()
    let interactor = SuperPayDashboardInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
    return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
  }
}


// MARK: - SuperPayDashboard 리블렛은 부모 리블렛의 뷰로서 사용되므로 부모로부터 필요한 component를 받아오는 게 좋아 보임

