//
//  MarketViewController.swift
//  SeSACSevenWeek_2
//
//  Created by Jack on 2/6/25.
//

import UIKit
import SnapKit

final class MarketViewController: UIViewController {
  
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "MarketCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
      
    private let viewModel = MarketViewModel()

    deinit {
        print("MarketViewController Deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureConstraints()
        bindData()
    }
    
    // ViewModel 에서 ViewController 로 바인딩해줄 데이터
    // ViewModel 에서 받아와서 View에 실시간 업데이트 할 것
    private func bindData() {
 
        // ViewController 의 ViewDidLoad 에서 ViewModel에 연락? 트리거!
        viewModel.inputViewDidLoadTrigger.value = ()
        viewModel.outputTitle.lazyBind { [weak self] value in
            self?.navigationItem.title = value
        }
        viewModel.outputMarket.lazyBind { _ in
            print("outputMarket closure excuted")
            self.tableView.reloadData()
        }
        viewModel.outputCellSelected.bind { data in
            print("outputCellSelected closure excuted")
            let nextVC = MarketDetailViewController()
            nextVC.viewModel.outputMarketTitle.value = data?.korean_name
            self.navigationController?.pushViewController(nextVC, animated: true)
            
//            self.navigationController?.pushViewController(EmptyViewController(), animated: true)
        }
    }
}

extension MarketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputMarket.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarketCell", for: indexPath)
        let data = viewModel.outputMarket.value[indexPath.row]
        cell.textLabel?.text = "\(data.korean_name) | \(data.english_name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let data = viewModel.outputMarket.value[indexPath.row]
        viewModel.inputCellSelectedTrigger.value = (data)
    }
    
}

extension MarketViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
    }
}

extension MarketViewController {
    
    private func configureView() {
        navigationItem.title = "마켓 목록"
        view.backgroundColor = .white
        view.addSubview(tableView)
    }

    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    
}
