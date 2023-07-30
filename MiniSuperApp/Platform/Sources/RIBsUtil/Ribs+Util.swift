//
//  File.swift
//  
//
//  Created by 박혜운 on 2023/07/30.
//

import Foundation

public enum DismissButtonType {
  case back, close
  
  public var iconSystemName: String {
    switch self {
    case .back:
      return "chevron.backward"
    case .close:
      return "xmark"
    }
  }
}
