//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs

protocol TopupRouting: Routing {
    func cleanupViews()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TopupListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TopupInteractor: Interactor, TopupInteractable {

    weak var router: TopupRouting?
    weak var listener: TopupListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
        //print("붙여졌는 지 확인")
    }

    override func willResignActive() {
        super.willResignActive()

        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
}
