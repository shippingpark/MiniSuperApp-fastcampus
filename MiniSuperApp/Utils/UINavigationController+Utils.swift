//
//  UINavigationController+Utils.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import UIKit

extension UIViewController {
  func setupNavigationItem(target: Any?, action: Selector?) {
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(systemName: "xmark",
                     withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
      ),
      style: .plain,
      target: target,
      action: action
    )
  }
}
