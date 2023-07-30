//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/28.
//

import UIKit

public protocol AdaptivePresentationControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}

//🍯Interactor가 UIKit을 모르게 하기 위해서 UIAdaptivePresentationControllerDelegate를 대신 받는 객체
public final class AdaptivePresentationControllerDelegateProxy: NSObject, UIAdaptivePresentationControllerDelegate {
  public weak var delegate: AdaptivePresentationControllerDelegate?
  
  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.presentationControllerDidDismiss()
  }
}
