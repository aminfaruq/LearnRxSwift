//
//  main.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 23/06/25.
//

import RxSwift

example(of: "just, of, from") {
    // 1
    let one = 1
    let two = 2
    let three = 3

    // 2
    let observable = Observable<Int>.just(one)
    let observable2 = Observable.of(one, two, three)
    let observable3 = Observable.of([one, two, three])
    let observable4 = Observable.from([one, two, three])
}
