//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/24.
//

import ModernRIBs
import Combine //balance 사용 위해

protocol SuperPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

//presenter 제공자
protocol SuperPayDashboardPresentable: Presentable {
  var listener: SuperPayDashboardPresentableListener? { get set }
  
  func updateBalance(_ balance: String)
}

protocol SuperPayDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

//🍯2️⃣ 프로토콜 생성하여 필요한 내역이 추가되어도 수정할 코드가 없도록
protocol SuperPayDashboardInteractorDependency {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {

  weak var router: SuperPayDashboardRouting?
  weak var listener: SuperPayDashboardListener?
  
  private let dependency: SuperPayDashboardInteractorDependency
  private var cancellables: Set<AnyCancellable>
  
  //🍯1️⃣ Interactor의 생성자에 바로 필요로 하는 객체를 넣어주면 추가될 때 마다 수정될 영역이 많아짐 (Builder)
    init(
      presenter: SuperPayDashboardPresentable,
      dependency: SuperPayDashboardInteractorDependency
    ) {
      self.dependency = dependency
      self.cancellables = .init()
      super.init(presenter: presenter)
      presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
      //cancellable이 self에 있으므로 weak self   
      dependency.balance.sink { [weak self] balance in //가져온 balance를 가지고 UI에 업데이트 시도
        //값을 업데이트 하고 싶다면, presentable 프로토콜에 적당한 메소드 선언
        self?.presenter.updateBalance(String(balance))
      }
      .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
