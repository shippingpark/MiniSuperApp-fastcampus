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
}

final class TopupComponent: Component<TopupDependency> {

    // TODO: Make sure to convert the variable into lower-camelcase.
    fileprivate var TopupViewController: ViewControllable {
        return dependency.topupBaseViewController
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
        let component = TopupComponent(dependency: dependency)
        let interactor = TopupInteractor()
        interactor.listener = listener
        return TopupRouter(interactor: interactor, viewController: component.TopupViewController)
    }
}
