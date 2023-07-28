//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/25.
//

import ModernRIBs
import UIKit

//뷰컨에서 액션이 발생하면 뷰컨은 presentableListner에게 알린다
protocol CardOnFileDashboardPresentableListener: AnyObject {
  func didTapAddPaymentMethod()
    
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {
  
  weak var listener: CardOnFileDashboardPresentableListener?
  
  private let headerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .horizontal
    return stackView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .semibold)
    label.text = "카드 및 계좌"
    return label
  }()
  
  private lazy var seeAllButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("전체보기", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private let cardOnFileStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .vertical
    stackView.spacing = 12
    return stackView
  }()
  
  private lazy var addMethodButton: AddPaymentMethodButton = {
    let button = AddPaymentMethodButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.roundCorners()
    button.backgroundColor = .gray
    button.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    setupViews()
  }
  
  //init을 하나 선언하면 requird를 만들어 줘야 함
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
  }
  
  func update(with viewModels: [PaymentMethodViewModel]) {
    cardOnFileStackView.arrangedSubviews.forEach{ $0.removeFromSuperview() }//update 할 때 일단 한 번 지워주고
    // [PaymentMethodViewModel] -> [PaymentMethodView]
    // 🍯 이런 식의 타입 변환은 map 과 flatMap을 활용하면 아주 간단하게 작성할 수 있다
    //let views = viewmodels.map(<#T##transform: (PaymentMethodViewModel) throws -> T##(PaymentMethodViewModel) throws -> T#>)
    //여기서 ViewModel -> View 로 바꾸는 작업을 생성자에서 하도록 하자
    
    let views = viewModels.map(PaymentMethodView.init)
    views.forEach {
      $0.roundCorners()
      cardOnFileStackView.addArrangedSubview($0)
    }
    cardOnFileStackView.addArrangedSubview(addMethodButton)
    
    // 🍯 추가되는 모든 뷰들에게 같은 높이 값을 먹일 수 있는 방법
    let heightConstraints = views.map{ $0.heightAnchor.constraint(equalToConstant: 60) }
    NSLayoutConstraint.activate(heightConstraints)
    // 🍯 짱이다!! 🍯
  }
  
  private func setupViews() {
    view.addSubview(headerStackView)
    view.addSubview(cardOnFileStackView)
    
    headerStackView.addArrangedSubview(titleLabel)
    headerStackView.addArrangedSubview(seeAllButton)

    NSLayoutConstraint.activate([
      headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
      headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      cardOnFileStackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
      cardOnFileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      cardOnFileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      cardOnFileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      addMethodButton.heightAnchor.constraint(equalToConstant: 60),

    ])
  }
  
  @objc
  private func seeAllButtonTapped() {
    
  }
  
  @objc
  private func addButtonDidTap() {
    listener?.didTapAddPaymentMethod()
  }
}



