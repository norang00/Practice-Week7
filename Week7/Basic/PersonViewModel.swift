//
//  PersonViewModel.swift
//  Week7
//
//  Created by Kyuhee hong on 2/5/25.
//

import Foundation

class PersonViewModel {
    
    let navigationTitle = "Person List"
    let resetTitle = "reset button"
    let loadTitle = "load button"
    
    // button 이 클릭되었다는 사실을 전해줄 변수
    var inputLoadButtonTapped: Observable<Void> = Observable(())
    
    // 테이블뷰에 보여줄 데이터
    var peopleList: Observable<[Person]> = Observable([])
    
    init() {
        inputLoadButtonTapped.bind { _ in
            self.peopleList.value = self.generateRandomPeople()
        }
    }
    
    
    
    private func generateRandomPeople() -> [Person] {
        return [
            Person(name: "James", age: Int.random(in: 20...70)),
            Person(name: "Mary", age: Int.random(in: 20...70)),
            Person(name: "John", age: Int.random(in: 20...70)),
            Person(name: "Patricia", age: Int.random(in: 20...70)),
            Person(name: "Robert", age: Int.random(in: 20...70))
        ]
    }
}
