//
//  CardOnFileInteractor.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import ModernRIBs

protocol CardOnFileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFilePresentable: Presentable {
    var listener: CardOnFilePresentableListener? { get set }
  func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileListener: AnyObject {
  func cardOnFileDidTapClose()
  func cardOnFileDidTapAddCard()
  func cardOnFileDidSelect(at Index: Int)
}

final class CardOnFileInteractor: PresentableInteractor<CardOnFilePresentable>, CardOnFileInteractable, CardOnFilePresentableListener {

    weak var router: CardOnFileRouting?
    weak var listener: CardOnFileListener?

  private let paymentMethods: [PaymentMethod]
  
    init(
      presenter: CardOnFilePresentable,
      paymentMethods: [PaymentMethod]
    ) {
      self.paymentMethods = paymentMethods
      super.init(presenter: presenter)
      presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
      presenter.update(with: paymentMethods.map(PaymentMethodViewModel.init)) //🍯 날아온 값을 원하는 형태로 가공하여 사용 
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
  
  func didTapClose() {
    listener?.cardOnFileDidTapClose() //부모에게 뒤로 가달라고 알려야 함 
  }
  
  func didSelectItem(at index: Int) {
    if index >= paymentMethods.count { //전체 숫자보다 크거나 같다면, 마지막 추가하기 버튼을 누른 것이므로 추가 화면으로 이동하고
      listener?.cardOnFileDidTapAddCard()
    } else {
      listener?.cardOnFileDidSelect(at: index) //카드가 선택되었다면, 이걸 부모에게 전달
    }
  }
}
