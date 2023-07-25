//
//  PaymentMethodView.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/25.
//

import UIKit

final class PaymentMethodView: UIView {
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 18, weight: .semibold)
    label.textColor = .white
    label.text = "우리은행"
    return label
  }()
  
  private let subtiltleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 15, weight: .semibold)
    label.textColor = .white
    label.text = "**** 9999"
    return label
  }()
  
  init(viewModel: PaymentMethodViewModel) {
    super.init(frame: .zero)
    setupView()
    
    nameLabel.text = viewModel.name
    subtiltleLabel.text = viewModel.digits
    backgroundColor = viewModel.color
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  func setupView() {
    addSubview(nameLabel)
    addSubview(subtiltleLabel)
    backgroundColor = .systemIndigo
    
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
      nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
      
      subtiltleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
      subtiltleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
    ])
  }
}




