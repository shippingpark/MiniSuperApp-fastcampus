//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/30.
//

import Foundation

//필요한 모듈마다 복사해서 사용
struct Formatter {
  static let balanceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
}
