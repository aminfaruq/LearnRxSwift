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
    }
}
