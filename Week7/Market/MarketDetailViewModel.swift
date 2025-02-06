//
//  MarketDetailViewModel.swift
//  Week7
//
//  Created by Kyuhee hong on 2/6/25.
//

import Foundation

final class MarketDetailViewModel {
    
//    var outputMarket: Observable<Market?> = Observable(nil)
    var outputMarketTitle: Observable<String?> = Observable(nil)

    init() {
        print("MarketDetailViewModel init")
    }
    
    deinit {
        print("MarketDetailViewModel deinit")
    }

}
