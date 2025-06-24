//
//  Subjects.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 24/06/25.
//

import Foundation
import RxSwift

// Define an error type to use in upcoming examples.
enum MyError: Error {
    case anError
}

// Expanding upon the use of the ternary operator in the previous example, you create a helper function to print the element if there is one, an error if there is one, or else the event itself. How convenient!
func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(_: label, _: (event.element ?? event.error) ?? event)
}


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
            subject.on(.next("2"))
            
            let subscriptionTwo = subject
                .subscribe { event in
                    print("2)", event.element ?? event)
                }
            
            subject.onNext("3")
            
            subscriptionOne.dispose()
            
            subject.onNext("4")
            
            // Add a completed event onto the subject, using the convenience method for on(.completed) . This terminates the subject’s observable sequence.
            subject.onCompleted()
            
            // Add another element onto the subject. This won’t be emitted and printed, though, because the subject has already terminated
            subject.onNext("5")
            
            // Dispose of the subscription.
            subscriptionTwo.dispose()
            
            let disposeBag = DisposeBag()
            
            // Subscribe to the subject, this time adding its disposable to a dispose bag.
            subject
                .subscribe {
                    print("3)", $0.element ?? $0)
                }
                .disposed(by: disposeBag)
            
            subject.onNext("?")
        }
        
        example(of: "BehaviourSubject") {
            // Create a new BehaviorSubject instance. Its initializer takes an initial value.
            let subject = BehaviorSubject(value: "Initial value")
            subject.onNext("X")
            let disposeBag = DisposeBag()
            
            subject
                .subscribe {
                    print(label: "1)", event: $0)
                }
                .disposed(by: disposeBag)
            
            // Add an error event onto the subject.
            subject.onError(MyError.anError)
            
            // Create a new subscription to the subject.
            subject
                .subscribe {
                    print(label: "2)", event: $0)
                }
                .disposed(by: disposeBag)
        }
        
    }
}
