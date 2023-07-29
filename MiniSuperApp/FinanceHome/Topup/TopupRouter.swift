//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs

protocol TopupInteractable: Interactable {
    var router: TopupRouting? { get set }
    var listener: TopupListener? { get set }
}

protocol TopupViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
    // this RIB does not own its own view, this protocol is conformed to by one of this
    // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: TopupInteractable, viewController: ViewControllable) {
        self.viewController = viewController
        super.init(interactor: interactor)
        interactor.router = self
    }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }

    // MARK: - Private

    private let viewController: ViewControllable
}
