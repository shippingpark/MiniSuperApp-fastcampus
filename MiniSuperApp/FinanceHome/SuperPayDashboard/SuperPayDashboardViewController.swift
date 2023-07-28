//
//  SuperPayDashboardViewController.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/24.
//

import ModernRIBs
import UIKit

protocol SuperPayDashboardPresentableListener: AnyObject {
  // TODO: Declare properties and methods that the view controller can invoke to perform
  // business logic, such as signIn(). This protocol is implemented by the corresponding
  // interactor class.
}

final class SuperPayDashboardViewController: UIViewController, SuperPayDashboardPresentable, SuperPayDashboardViewControllable {

  weak var listener: SuperPayDashboardPresentableListener?
  
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
    label.text = "슈퍼페이 잔고"
    return label
  }()
  
  //뷰컨이 생성된 다음에 불려야 하기 때문에 let 불가 (타겟 설정 시 self 호출하기 때문)
  //lazy var 로 선언
  private lazy var topupButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("충전하기", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(topupButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private let cardView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 16
    view.layer.cornerCurve = .continuous //좀 더 부드러운 라운딩
    view.backgroundColor = .systemIndigo
    return view
  }()
  
  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .semibold)
    label.text = "원"
    label.textColor = .white
    return label
  }()
  
  //✨비즈니스 로직이 반영될 UI, 변동이 있는 데이터
  private let balanceAmountLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .semibold)
    label.text = "10,000"
    label.textColor = .white
    return label
  }()
  
  private let balanceStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.alignment = .fill
    stack.distribution = .equalSpacing
    stack.axis = .horizontal
    stack.spacing = 4
    return stack
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
  
  //공통적으로 호출되어 View들을 setup해줄 함수
  private func setupViews() {
    view.addSubview(headerStackView)
    view.addSubview(cardView)
    
    headerStackView.addArrangedSubview(titleLabel)
    headerStackView.addArrangedSubview(topupButton)
    
    cardView.addSubview(balanceStackView)
    balanceStackView.addArrangedSubview(balanceAmountLabel)
    balanceStackView.addArrangedSubview(currencyLabel)
    
    NSLayoutConstraint.activate([
      headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
      headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      cardView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
      cardView.heightAnchor.constraint(equalToConstant: 180),
      cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
      
      balanceStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
      balanceStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
    ])
  }
  
  func updateBalance(_ balance: String) {
    balanceAmountLabel.text = balance
  }
  
  
  @objc
  private func topupButtonDidTap() {
    
  }
}



// MARK: - 변동이 있는 데이터, 여러 곳에서 쓰일 수 있는 데이터는
// ⭐️Stream으로 관리하는 것이 좋다⭐️
// Combine 사용
// Subject, Publisher, Operator 종류가 적어 가벼운 라이브러리 하나를 추가적으로 쓸 것
// Combine Ext 라이브러리
//
// MARK: - 변동이 있는 데이터 전달 과정 정리
//✏️ 데이터 전달 받고자 하는 리블렛 : SuperPayDashboard / ✏️ 데이터 생성 및 전달해줄 리블렛 : FinanceHome
//📝 부모 리블렛이 자식 리블렛에게 데이터를 readOnlyPublisher로 전달해주게 만들자
//1️⃣ FinanceHomeBuilder가 자식의 component를 생산할 책임이 있으므로
// - FinanceHomeComponent에 balance 추가
// 🍯 Tip : 값을 생성할 수 있는 객체와 없는 객체를 분리하는 방법
// - ReadOnlyCurrentValuePublisher / CurrentValuePublisher 사용하여 send 이벤트 전달 가능 객체와 불가능 객체 구분
// ReadOnlyCurrentValuePublisher는 balance, CurrentValuePublisher 는 private 으로 선언
// ReadOnlyCurrentValuePublisher는
// 값을 전달받는 자식 리블렛이 { balancePublisher } 으로 getter 만 구현!
// 더불어 부모 객체에 해당하는 ReadOnlyCurrentValuePublisher이 타입 캐스팅 되어 send 메서드에는 접근 불가
// 🤔 부모로부터 받은 component : dependency
//2️⃣ dependency를 주입받을 SuperPayDashboardBuilder는 dependency 프로토콜에 전달 받기를 원하는 값 balance를 추가
//3️⃣ build 메서드 내에서 component 생성 및 필요한 생성자들 담을 때, Interactor가 dependency 가져감
//4️⃣ 받은 dependency에서 원하는 값인 balance 꺼내서 didBecomeActive할 때 사용
//5️⃣ presenter (ViewController) 에게 전달해줄 데이터 SuperPayDashboardPresentable 메서드로 정의 
//6️⃣ 정의된 메서드 생성하여 데이터 값 전달받아 수행할 일 적용 (UI Update)
