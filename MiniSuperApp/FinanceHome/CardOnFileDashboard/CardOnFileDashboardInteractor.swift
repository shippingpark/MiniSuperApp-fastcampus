//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/25.
//

import ModernRIBs
import Combine

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
  var listener: CardOnFileDashboardPresentableListener? { get set }
  func update(with viewmodels: [PaymentMethodViewModel]) //백엔드 통신 값 전달 받을 메서드
}

protocol CardOnFileDashboardListener: AnyObject { //부모 Interactor에게 원하는 전달사항 전하기 가능
  func cardOnFileDashboardDidTapAddPaymentMethod()
}

//주입 받을 dependency 생성
protocol CardOnFileDashboardInteractorDependency {
  var cardsOnFileRepository: CardOnFileRepository { get } //주입 받을 dependency 생성
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

  weak var router: CardOnFileDashboardRouting?
  weak var listener: CardOnFileDashboardListener? //부모 리불렛의 Interactor
  
  private let dependency: CardOnFileDashboardInteractorDependency
  private var cancellables: Set<AnyCancellable>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
      presenter: CardOnFileDashboardPresentable,
      dependency: CardOnFileDashboardInteractorDependency
    ) {
      self.dependency = dependency
      self.cancellables = .init()
      super.init(presenter: presenter)
      presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
      
      //🍯 자꾸 weak self 쓰게 되니 방지하는 법 (번거로우니)
      dependency.cardsOnFileRepository.cardOnFile.sink { method in
        let viewModels = method.prefix(4).map(PaymentMethodViewModel.init)
        self.presenter.update(with: viewModels)
      }.store(in: &cancellables)
        // TODO: Implement business logic here.
    }
      //🍯 인터렉터가 디태치 되기 직전에 불리는 메서드에 넣어줌
    override func willResignActive() {
        super.willResignActive()
      cancellables.forEach { $0.cancel() } //self에 캡쳐되어 있던 것들이 전부 사라지므로, retain 사이클이 사라지게 됨
      cancellables.removeAll()
    }
  
  //전체적인 구조를 고려해 보았을 때, 화면의 일부인 여기서 모달창을 (CarOnFile) 띄우는 것 보다는
  //FinancHome에서 띄우는 것이 적절해 보임 (바로 router에게 요청하지 않겠다는 뜻)
  func didTapAddPaymentMethod() {
    listener?.cardOnFileDashboardDidTapAddPaymentMethod()
  }
}


// MARK: - Ribs 아키텍쳐의 이해 🍯
//리블렛끼리 소통하고 정보를 주고 받을 때에는 Interactor (리블렛의 두뇌)
//부모가 자식에게, 자식이 부모에게 데이터를 줄 때에는 stream을 이용합니다
//왜냐? 부모가 여러 자식을 둘 수 있기 때문임
//1:N 관계에서는 stream으로 데이터를 전달하는 것이 더 유연함
//자식은 하나의 부모 리블렛 밖에 가질 수 없으므로 델리게이트를 사용하여 소통한다
