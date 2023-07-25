//
//  NumberFormatter.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/25.
//

import Foundation

//balance 값을 읽기 쉽게 바꿔주는 Formatter
//🤔 Interactor에서 바로 쓸까, 아니면 dependency에 넣어줘서 쓸까 고민
//=> Ribs를 사용해보는 목적으로 dependency에 넣어주는 것으로 진행 
struct Formatter {
  static let balanceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
}
 
