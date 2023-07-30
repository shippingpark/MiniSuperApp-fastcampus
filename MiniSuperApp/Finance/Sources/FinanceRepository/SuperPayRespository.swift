//
//  SuperPayRespository.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/29.
//

import Foundation
import Combine
import CombineUtil

public protocol SuperPayRepository {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
  func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> //API 요청 결과
}

public final class SuperPayRepositoryImp: SuperPayRepository {
  
  public var balance: ReadOnlyCurrentValuePublisher<Double> { balanceSubject }
  private let balanceSubject = CurrentValuePublisher<Double>(0)
  
  public func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
    return Future<Void, Error> { [weak self] promise in
      self?.bgQueue.async {
        Thread.sleep(forTimeInterval: 2)
        promise(.success(())) //성공한 뒤 balance를 한 번 업데이트 해야함
        let newBalance = (self?.balanceSubject.value).map{ $0 + amount } //기존에 있던 value에 새로운 amount를 더해주고
        newBalance.map{ self?.balanceSubject.send($0) }
      }
    }
    .eraseToAnyPublisher()
  }
  
  private let bgQueue = DispatchQueue(label: "topup.respository.queue") //딜레이를 주기 위한 큐
  
  public init() { }
}
