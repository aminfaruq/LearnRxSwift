//
//  Subjects.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 24/06/25.
//

import Foundation
import RxSwift

struct SubjectsCommand: Runnable {
    func run() throws {
        example(of: "PublishSubject") {
            let subject = PublishSubject<String>()
            
            subject.on(.next("Is anyone listening?"))
            
            let subscriptionOne = subject
                .subscribe(onNext: { string in
                    print(string)
                })
            
            subject.on(.next("1"))
        }
        
    }
}
