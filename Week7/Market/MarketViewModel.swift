//
//  MarketViewModel.swift
//  SeSACSevenWeek_2
//
//  Created by Jack on 2/6/25.
//

import Foundation
import Alamofire

final class MarketViewModel {
    
    let inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    let inputCellSelectedTrigger: Observable<Market?> = Observable(nil)
    
    let outputTitle: Observable<String?> = Observable(nil)
    let outputMarket: Observable<[Market]> = Observable([])
    let outputCellSelected: Observable<Market?> = Observable(nil)
    
    init() {
        print("MarketViewModel Init")
        
        inputViewDidLoadTrigger.lazyBind { _ in
            print("inputViewDidLoadTrigger closure excuted")
            self.fetchUpbitMarketAPI()
        }
        
        inputCellSelectedTrigger.lazyBind { market in
            print("inputCellSelected closure excuted")
            self.outputCellSelected.value = (market)
        }
    }
    
    deinit {
        print("MarketViewModel Deinit")
    }
    
    func fetchUpbitMarketAPI() {
        let url = "https://api.upbit.com/v1/market/all"
        
        AF.request(url).responseDecodable(of: [Market].self) { response in
            switch response.result {
            case .success(let success):
//                dump(success)
                print("success")
                self.outputMarket.value = success
                self.outputTitle.value = success.randomElement()?.korean_name
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
