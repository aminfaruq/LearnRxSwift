//
//  SubjectsChallenges.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 24/06/25.
//

import RxSwift
import RxRelay

struct SubjectsChallenges: Runnable {
    
    func run() throws {
        example(of: "PublishSubject") {
            
            let disposeBag = DisposeBag()
            
            let dealtHand = PublishSubject<[(String, Int)]>()
            
            func deal(_ cardCount: UInt) {
                var deck = cards
                var cardsRemaining = deck.count
                var hand = [(String, Int)]()
                
                for _ in 0..<cardCount {
                    let randomIndex = Int.random(in: 0..<cardsRemaining)
                    hand.append(deck[randomIndex])
                    deck.remove(at: randomIndex)
                    cardsRemaining -= 1
                }
                
                // Add code to update dealtHand here
                
                let handPoints = points(for: hand)
                
                if handPoints > 21 {
                    dealtHand.on(.error(HandError.busted(points: handPoints)))
                } else {
                    dealtHand.on(.next(hand))
                }
            }
            
            // Add subscription to dealtHand here
            let subscription = dealtHand
                .subscribe(
                    onNext: { hand in
                        print("Card in hand: \(cardString(for: hand)), Point: \(points(for: hand))")
                    },
                    onError: { error in
                        print(error)
                    }
                )
            
            
            subscription.disposed(by: disposeBag)
            
            deal(3)
        }
    }
}
