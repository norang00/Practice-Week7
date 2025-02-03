//
//  NetworkManager.swift
//  Week7
//
//  Created by Kyuhee hong on 2/3/25.
//

import Foundation
import Alamofire

struct Lotto: Decodable {
    let drwNo1: String
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    // 핸들러 두개 일때
    func getLotto(successHandler: @escaping (Lotto) -> Void,
                  failHandler: @escaping (AFError) -> Void) {
        AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=1154")
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Lotto.self) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    successHandler(value)
                case .failure(let error):
                    print(error)
                    failHandler(error)
                }
            }
    }
    
    // 핸들러 하나로 통일해보기
    func getLotto2(completionHandler: @escaping (Lotto?, AFError?) -> Void) {
        AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=1154")
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Lotto.self) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    completionHandler(value, nil)
                case .failure(let error):
                    print(error)
                    completionHandler(nil, error)
                }
            }
    }
    
    // 스위치문도 제거해보기
    func getLotto2_1(completionHandler: @escaping (Lotto?, AFError?) -> Void) {
        AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=1154")
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Lotto.self) { response in
                completionHandler(response.value, response.error)
            }
    }
    
    // Result Type 사용해보기
    // 매개변수를 Result 열거형 타입의 제네릭으로 보내줘보기 (결과는 어차피 둘 중 하나만 오는 것이기 때문에, 열거형으로 하나만 받아오도록 해주자)
    func getLotto3(completionHandler: @escaping (Result<Lotto, AFError>) -> Void) {
        AF.request("https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=1154")
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Lotto.self) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    completionHandler(.success(value))
                case .failure(let error):
                    print(error)
                    completionHandler(.failure(error))
                }
            }
    }
}
