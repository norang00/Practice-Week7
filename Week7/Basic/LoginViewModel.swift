//
//  LoginViewModel.swift
//  Week7
//
//  Created by Kyuhee hong on 2/5/25.
//

import Foundation

class LoginViewModel {
    
    // 실시간으로 달라지는 텍스트필드의 값을 전달 받아올 것
    let inputID: Field<String?> = Field(nil)
    let inputPW: Field<String?> = Field(nil)
    // 텍스트만 레이블로 보내기
    let outputValidText = Field("")
    // 버튼 활성화 상태 보내기
    let outputButtonStatus = Field(false)
    
    init() {
        // inputID 의 value 값이 바뀌면 어떻게 할까?
        inputID.bind { _ in
            // inputID.value = value
            self.validate()
        }
        
        inputPW.bind { _ in
            self.validate()
        }
        
        
    }
    
    func validate() {
        guard let id = inputID.value, let pw = inputPW.value else {
            outputValidText.value = "nil입니당"
            return
        }
        
        if id.count >= 4 && pw.count >= 4 {
            outputValidText.value = "굿굿"
            outputButtonStatus.value = false
        } else {
            outputValidText.value = "id, password 4자리 이상입니다."
        }
    }
    
}
