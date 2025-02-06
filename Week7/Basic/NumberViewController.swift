//
//  NumberViewController.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/5/25.
//

import UIKit
import SnapKit

// 1. init 클래스의 생성자 작성
// 2. didSet 저장 프로퍼티의 프로퍼티 옵저버 추가
// 3. closure클로저 생성, 프로퍼티 옵저버에서 사용하던 함수 이동
// 4. init 생성시에도 불러주자
class Field<T> {
    private var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        // 값이 한번 바뀌기 전까지(bind 가 호출되기 전까지) 실행 안됨 즉, 초기값에 대해서는 적용 안됨
        // bind 작성 구문을 빌드 직후에 한번 동작시키고 싶은 경우에는 적어주면 좋다
        // 근데 각각 다른 케이스에 사용할 것 같으면 같은 내용으로 bind 하나 더 만들면 된다 -> lazyBind
//        closure(value)
        self.closure = closure
    }
    
    func lazyBind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}

class NumberViewController: UIViewController {
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "금액 입력"
        textField.keyboardType = .numberPad
        return textField
    }()
    private let formattedAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "값을 입력해주세요"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    let viewModel = NumberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let a = Field("jack")
//        a.bind { example1, example2 in
//            print("value chaged! \(example1) -> \(example2)")
//            self.navigationItem.title = example2
//        }
//        a.value = "bran"
//        a.value = "den"
//        a.value = "hue"

        configureUI()
        configureConstraints()
        configureActions()
        
        // viewModel 의 outputText 가 바뀌면 실행할 옵저버 함수를 걸어줌
        viewModel.outputText.bind { text in
            print("outputText", text)
            self.formattedAmountLabel.text = text
        }
        
        // viewModel 의 outputTextColor 가 바뀌면 실행할~
        viewModel.outputTextColor.bind { color in
            self.formattedAmountLabel.textColor = color ? .systemBlue : .systemRed
        }
    }
 
    @objc private func amountChanged() {
        viewModel.inputField.value = amountTextField.text
    }
}

extension NumberViewController {
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(amountTextField)
        view.addSubview(formattedAmountLabel)
    }

    private func configureConstraints() {
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        formattedAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.left.right.equalTo(amountTextField)
        }
    }

    private func configureActions() {
        amountTextField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
    }

}
