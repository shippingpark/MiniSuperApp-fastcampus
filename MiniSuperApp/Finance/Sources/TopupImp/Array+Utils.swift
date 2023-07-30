//
//  File.swift
//  
//
//  Created by 박혜운 on 2023/07/30.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
