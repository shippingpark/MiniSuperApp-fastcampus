//
//  File.swift
//  
//
//  Created by 박혜운 on 2023/07/30.
//

import Foundation
import ModernRIBs

public protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> Routing
}

public protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFinish()
}
