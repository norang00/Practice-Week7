//
//  BoxOfficeViewModel.swift
//  SeSACSevenWeek_2
//
//  Created by Jack on 2/6/25.
//

import Foundation
import Alamofire

class BoxOfficeViewModel {
    
    let inputSelectedDate: Observable<Date> = Observable(Date())
    let inputSearchButtonTapped: Observable<Void?> = Observable(nil)
    
    let outputSelectedDate: Observable<String> = Observable("")
    let outputBoxOffice: Observable<[Movie]> = Observable([])
        
    var dateQuery: String = ""
    
    init() {
        print("BoxOfficeViewModel Init")
        
        bindData()
        callBoxOffice(date: "20241223")
    }
    
    deinit {
        print("BoxOfficeViewModel Deinit")
    }
    
    private func bindData() {
        inputSelectedDate.bind { date in
            self.convertDate(date: date)
        }
        
        inputSearchButtonTapped.lazyBind { _ in
            self.callBoxOffice(date: self.dateQuery)
        }
    }
    
    private func convertDate(date: Date) {
        let format1 = DateFormatter()
        format1.dateFormat = "yy년 MM월 dd일"
        let string1 = format1.string(from: date)
        outputSelectedDate.value = string1

        let format2 = DateFormatter()
        format2.dateFormat = "yyyyMMdd"
        dateQuery = format2.string(from: date)
    }
    
    private func callBoxOffice(date: String) {
        let url = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=87fea7fcd65acfc45d6c523a3ca8711e&targetDt=\(date)"
        
        AF.request(url).responseDecodable(of: BoxOfficeResult.self) { response in
            switch response.result {
            case .success(let success):
                dump(success.boxOfficeResult.dailyBoxOfficeList)
                self.outputBoxOffice.value = success.boxOfficeResult.dailyBoxOfficeList
            case .failure(let failure):
                print(failure)
            }
        }
    }

}
