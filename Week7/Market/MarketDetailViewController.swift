//
//  MarketDetailViewController.swift
//  Week7
//
//  Created by Kyuhee hong on 2/6/25.
//

import UIKit

final class MarketDetailViewController: UIViewController {

    let viewModel = MarketDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("MarketDetailViewController", #function)
    }
    
    deinit {
        print("MarketDetailViewController", #function)
    }
    
    func bindData() {
        viewModel.outputMarketTitle.bind { data in
            print("MarketDetailViewController outputMarketTitle bind")
            self.navigationItem.title = data ?? "no market"
        }
        
    }
    
    
    func configureView() {
        view.backgroundColor = .lightGray
    }
}
