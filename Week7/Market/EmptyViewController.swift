//
//  EmptyViewController.swift
//  Week7
//
//  Created by Kyuhee hong on 2/6/25.
//

import UIKit

class EmptyViewModel {
    init() {
        print("EmptyViewModel", #function)
    }
    
    deinit {
        print("EmptyViewModel", #function)
    }
}

class EmptyViewController: UIViewController {
    
    let viewModel = EmptyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
        
        print("EmptyViewController", #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        print("EmptyViewController", #function)
    }

    deinit {
        print("EmptyViewController", #function)
    }

}
