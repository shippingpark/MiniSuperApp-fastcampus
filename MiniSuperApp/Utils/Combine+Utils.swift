//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/24.
//

import Combine
import CombineExt
import Foundation

//유용하게 쓸 Publisher
//일종의 CurrentValueSubject의 변형
//최신 값을 받되, send는 할 수 없도록

//부모 객체인 readOnly를 받아서 데이터만 읽을 수 있게
//잔액을 사용하는 객체
public class ReadOnlyCurrentValuePublisher<Element>: Publisher {
  
  public typealias Output = Element
  public typealias Failure = Never
  
  //현재 잔액 값을 받아갈 수 있는 value property 
  public var value: Element {
    currentValueRelay.value
  }
  
  fileprivate let currentValueRelay: CurrentValueRelay<Output>
  
  fileprivate init(_ initialValue: Element) {
    currentValueRelay = CurrentValueRelay(initialValue)
  }
  
  public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Element == S.Input {
    currentValueRelay.receive(subscriber: subscriber)
  }
}


//값을 전송할 수 있는 Publisher
//잔액을 관리하는 객체가 생성할 Publisher
public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
  
  typealias Output = Element
  typealias Failure = Never
  
  public override init(_ initialValue: Element) {
    super.init(initialValue)
  }
  
  //값이 바뀔 때 마다 send
  public func send(_ value: Element) {
    currentValueRelay.accept(value)
  }
  
}
