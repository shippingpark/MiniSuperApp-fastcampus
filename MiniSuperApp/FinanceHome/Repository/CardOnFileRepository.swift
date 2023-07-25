//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by 박혜운 on 2023/07/25.
//

import Foundation


//서버 API를 호출해서 유저에게 등록된 카드 목록을 가져오는 역할
//
protocol CardOnFileRepository {
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { get }
}

//Repository를 구현한 Imp 객체
final class CardOnFileRepositoryImp: CardOnFileRepository {
  //외부에 노출 될 cardOnFile
  //Interactor에서 cardOnFile 값을 읽어서 UI를 업데이트 해 주면 된다 
  var cardOnFile: ReadOnlyCurrentValuePublisher<[PaymentMethod]> { paymentMethodsSubject }
  
  private let paymentMethodsSubject = CurrentValuePublisher<[PaymentMethod]>([
    PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
    PaymentMethod(id: "1", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
    PaymentMethod(id: "2", name: "현대카드", digits: "8121", color: "#f19a38ff", isPrimary: false),
    PaymentMethod(id: "3", name: "국민은행", digits: "2812", color: "#f19a38ff", isPrimary: false),
    PaymentMethod(id: "4", name: "카카오뱅크", digits: "8751", color: "#f19a38ff", isPrimary: false)
  ]) //마지막 컬러 두 자리는 알파값임 . ff라고 하면 알파 값이 없는 solid color
}


// MARK: - 백엔드로부터 전달 받은 데이터 UI에 표시하는 과정
//1️⃣ 백엔드에서 날아온 Model을 의미하는 Method, 해당 모델을 View에 올릴 형태로 가공하는 ViewModel 객체 생성
//2️⃣ Repository 생성하여 받아오길 원하는 데이터 속성 생성, RepositoryImp로 상세 구현
//3️⃣ Repository를 생성하는 위치는 어디일까? 바로 Builder
//4️⃣ Router는 전달 받은 것을 가지고 필요한 구간에 연결 (ViewController의 Listner로 자신을 등록하며, 직접 viewcontroller 메서드를 호출하여 자식 viewcontroller를 나의 ViewController에 전달 (올리기 위해) )하는 메서드 생성
//5️⃣ 그 메서드를 실행하는 것은 Interactor
//6️⃣ 부모에 의해 연결이 완료된 자식 리블렛은 이제 원하는 데이터를 전달 받을 경로를 고려해야함 
//7️⃣ 부모가 내려주길 바라는 정보는 dependency에 작성, Interactor는 dependency를 통해 받은 값을 sink (구독) 한 뒤 present(VC)에게 전달
//8️⃣ 받은 값을 원하는 형태의 UI로 바꾸어 update <- 이 메서드는 present 프로토콜에 명시
