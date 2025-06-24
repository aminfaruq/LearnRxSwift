//
//  Subjects.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 24/06/25.
//

import Foundation
import RxSwift
import RxRelay

// Define an error type to use in upcoming examples.
enum MyError: Error {
    case anError
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
        
        example(of: "ReplaySubject") {
            // Create a new replay subject with a buffer size of 2 . Replay subjects are initialized using the type method create(bufferSize:).
            let subject = ReplaySubject<String>.create(bufferSize: 2)
            let disposeBag = DisposeBag()
            
            // Add three elements onto the subject.
            subject.onNext("1")
            subject.onNext("2")
            subject.onNext("3")
            
            // Create two subscriptions to the subject.
            subject.subscribe {
                print(label: "1)", event: $0)
            }
            .disposed(by: disposeBag)
            
            subject.subscribe {
                print(label: "2)", event: $0)
            }
            .disposed(by: disposeBag)
            
            subject.onNext("4")
            subject.onError(MyError.anError)
            subject.dispose()
            
            subject.subscribe {
                print(label: "3)", event: $0)
            }
            .disposed(by: disposeBag)
        }
        
        example(of: "PublishRelay") {
            let relay = PublishRelay<String>()
            
            let disposeBag = DisposeBag()
            
            relay.accept("Knock knock, anyone home?")
            
            relay.subscribe(
                onNext: {
                    print($0)
                }
            )
            .disposed(by: disposeBag)
            
            relay.accept("1")
        }
    }
}
