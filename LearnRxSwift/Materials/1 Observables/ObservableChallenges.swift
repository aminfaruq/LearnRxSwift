//
//  ObservableChallenges.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 24/06/25.
//

import RxSwift

struct ObservableChallenges: Runnable {
    
    func run() throws {
        example(of: "(never) do challenge") {
            let disposeBag = DisposeBag()
            // 'never' creates an observable that sends no elements and never finishes. It just sits there silently.
            Observable<Void>.never()
            // Adding Handler
                .do(
                    onSubscribe: {
                        print("Subscribed!")
                    }
                )
            // Because the 'never' observable does nothing, none of these blocks will ever be called.
                .subscribe(
                    onNext: { element in
                        print(element)
                    },
                    onCompleted: {
                        print("Completed")
                    }
                )
                .disposed(by: disposeBag)
        }
        
        
        example(of: "(never) debug challenge") {
            let disposeBag = DisposeBag()
            // 'never' creates an observable that sends no elements and never finishes. It just sits there silently.
            Observable<Void>.never()
            // Adding Handler
                .debug("never observable")
            // Because the 'never' observable does nothing, none of these blocks will ever be called.
                .subscribe(
                    onNext: { element in
                        print(element)
                    },
                    onCompleted: {
                        print("Completed")
                    }
                )
                .disposed(by: disposeBag)
        }
    }
}
