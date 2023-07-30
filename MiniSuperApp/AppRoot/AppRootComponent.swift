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
import Topup
import TopupImp

final class AppRootComponent: Component<AppRootDependency>, AppHomeDependency, FinanceHomeDependency, ProfileHomeDependency, TransportHomeDependency, TopupDependency  {
  
  //부모에게 생성을 미뤘기 때문에, 여기서 생성자 넣어달라는 에러발생🍷
  
  var cardOnFileRepository: CardOnFileRepository
  var superPayRepository: SuperPayRepository
  
  lazy var transportHomeBuildable: TransportHomeBuildable  = {
    return TransportHomeBuilder(dependency: self) //self 를 참조하기에 lazy 🍷
  }()
  
  lazy var topupBuildable: TopupBuildable = {
    return TopupBuilder(dependency: self) // 🍷
  }()
  
  var topupBaseViewController: ViewControllable { rootViewController.topViewControllable } //그 최상단을 받는다
  
  private let rootViewController: ViewControllable //앱의 시작점이 되는 탭바 컨트롤러 받아서
  
  init(
    dependency: AppRootDependency,
    cardOnFileRepository: CardOnFileRepository,
    superPayRepository: SuperPayRepository,
    rootViewController: ViewControllable
  ) {
    self.cardOnFileRepository = cardOnFileRepository
    self.superPayRepository = superPayRepository
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
  
  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
} //앱의 최초 실행점에 해당, 앞으로 점점 커질 것 같기 때문에 별도의 파일로 분리
