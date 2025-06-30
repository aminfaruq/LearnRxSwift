//
//  TransformingCommand.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 30/06/25.
//

import Foundation
import RxSwift

struct TransformingCommand: Runnable {
    func run() throws {
        
        example(of: "toArray") {
            let disposeBag = DisposeBag()
            
            // Create a finite observable of letters.
            Observable.of("A", "B", "C")
            // Use toArray to transform the individual elements into an array.
                .toArray()
                .subscribe(onSuccess: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
    }
}
