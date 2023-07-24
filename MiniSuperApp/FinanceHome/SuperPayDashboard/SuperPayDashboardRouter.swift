//
//  SuperPayDashboardRouter.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/24.
//

import ModernRIBs

protocol SuperPayDashboardInteractable: Interactable {
    var router: SuperPayDashboardRouting? { get set }
    var listener: SuperPayDashboardListener? { get set }
}

protocol SuperPayDashboardViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class SuperPayDashboardRouter: ViewableRouter<SuperPayDashboardInteractable, SuperPayDashboardViewControllable>, SuperPayDashboardRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: SuperPayDashboardInteractable, viewController: SuperPayDashboardViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
