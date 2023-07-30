//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/30.
//

import Foundation
import AppHome
import FinanceHome
import ProfileHome
import FinanceRepository
import ModernRIBs
import TransportHome //빌더블 있는 위치
import TransportHomeImp

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency  {
  var cardOnFileRepository: CardOnFileRepository
  var superPayRepository: SuperPayRepository
  
  lazy var transportHomeBuildable: TransportHomeBuildable  = {
    return TransportHomeBuilder(dependency: self) //self 를 참조하기에 lazy
  }()
  
  init(
    dependency: AppRootDependency,
    cardOnFileRepository: CardOnFileRepository,
    superPayRepository: SuperPayRepository
  ) {
    self.cardOnFileRepository = cardOnFileRepository
    self.superPayRepository = superPayRepository
    super.init(dependency: dependency)
  }
  
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
} //앱의 최초 실행점에 해당, 앞으로 점점 커질 것 같기 때문에 별도의 파일로 분리
