//
//  NumberViewModel.swift
//  Week7
//
//  Created by Kyuhee hong on 2/5/25.
//

import Foundation

class NumberViewModel {
    
    // ViewController 에서 사용자가 받아온 값 여기 넣어줄 것임
    var inputField: Field<String?> = Field(nil)
    
    // ViewController Label 에 보여줄 최종 텍스트
    var outputText = Field("")
    
    // ViewController Label 컬러로 사용할 것 => 빨강 파랑 두가지만 쓴다고 해보자
    var outputTextColor = Field(false)
    
    init() {
        print("NumberViewModel")
        // 생성되면서 inputField 값을 받아올 옵저버 함수를 걸어줌
        inputField.bind { test in
            self.validation()
        }
    }
    
    private func validation() {
        // 공백 - 값을 입력해주세요
        // 숫자가 아닌 값 - 숫자를 입력해주세요
        // 너무 큰 수 - 범위 내에서 입력해주세요
        // 단위 표시 - 1000 단위에서 콤마 찍어주기
        // -> 이러한 기능(로직)들을 ViewController 에서 덜어내어 분리하는 것이 목적
        
        //1) Optional Handling
        guard let text = inputField.value else {
            outputText.value = ""
            outputTextColor.value = false
            return
        }
        
        //2) Empty Handling
        if text.isEmpty {
            outputText.value = "값을 입력해주세요"
            outputTextColor.value = false
            return
        }
        
        //3) IsNumber Check
        guard let num = Int(text) else {
            outputText.value = "숫자만 입력해주세요"
            outputTextColor.value = false
            return
        }
        
        //4) Number Range Check
        if num > 0, num <= 1000000 {
            let format = NumberFormatter()
            format.numberStyle = .decimal
            let result = format.string(from: num as NSNumber)!
            outputText.value = "₩"+result
            outputTextColor.value = true
        } else {
            outputText.value = "백만원 이하를 입력해주세요"
            outputTextColor.value = false
        }
    }
    
    
}
