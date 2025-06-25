//
//  FilteringOperatorsCommand.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 26/06/25.
//
import RxSwift
import RxRelay

struct FilteringCommand: Runnable {
    func run() throws {
        example(of: "ignore") {
            // Create a strikes subject.
            let strikes = PublishSubject<String>()
            
            let disposeBag = DisposeBag()
            
            // Subscribe to all strikes ’ events, but ignore all next events by using `ignoreElements`.
            strikes
                .ignoreElements()
                .subscribe { _ in
                    print("You're out!")
                }
                .disposed(by: disposeBag)
            
            strikes.onNext("X")
            strikes.onNext("X")
            strikes.onNext("X")
            
            strikes.onCompleted()
        }
        
        example(of: "elementAt") {
            // You create a subject.
            let strikes = PublishSubject<String>()
            
            let disposeBag = DisposeBag()
            
            // You subscribe to the next events, ignoring all but the 3rd next event, found at index 2 .
            strikes
                .element(at: 2)
                .subscribe(onNext: { _ in
                    print("You're out!")
                })
                .disposed(by: disposeBag)
            
            strikes.onNext("X")
            strikes.onNext("X")
            strikes.onNext("X")
        }
        
        example(of: "filter") {
            let disposeBag = DisposeBag()
            
            // 1
            Observable.of(1,2,3,4,5,6)
            // 2
                .filter({ $0.isMultiple(of: 2) })
            // 3
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
    }
}
