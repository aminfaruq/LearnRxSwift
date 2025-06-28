//
//  OperatorsChallenges.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 28/06/25.
//

import RxSwift
import Foundation

struct OperatorsChallenges: Runnable {
    
    func run() throws {
        example(of: "Challenge 1") {
            let disposeBag = DisposeBag()
            
            let contacts = [
                "603-555-1212": "Florent",
                "212-555-1212": "Shai",
                "408-555-1212": "Marin",
                "617-555-1212": "Scott"
            ]
            
            func phoneNumber(from inputs: [Int]) -> String {
                var phone = inputs.map(String.init).joined()
                
                phone.insert("-", at: phone.index(
                    phone.startIndex,
                    offsetBy: 3)
                )
                
                phone.insert("-", at: phone.index(
                    phone.startIndex,
                    offsetBy: 7)
                )
                
                return phone
            }
            
            let input = PublishSubject<Int>()
            
            // Add your code here
            input
                .skip(while: { $0 == 0 })
                .filter({ $0 < 10 })
                .take(10)
                .toArray()
                .subscribe(onSuccess: {
                    let phoneNum = phoneNumber(from: $0)

                    if let contact = contacts[phoneNum] {
                        print(contact)
                    } else {
                        print("Contact not found")
                    }
                })
                .disposed(by: disposeBag)
            
            input.onNext(0)
            input.onNext(603)
            
            input.onNext(2)
            input.onNext(1)
            
            // Confirm that 7 results in "Contact not found",
            // and then change to 2 and confirm that Shai is found
            input.onNext(7)
            
            "5551212".forEach {
                if let number = (Int("\($0)")) {
                    input.onNext(number)
                }
            }
            
            input.onNext(9)
        }
    }
}
