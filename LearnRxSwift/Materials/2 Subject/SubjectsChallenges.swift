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
        
        example(of: "BehaviorRelay") {
            enum UserSession {
                case loggedIn, loggedOut
            }
            
            enum LoginError: Error {
                case invalidCredentials
            }
            
            let disposeBag = DisposeBag()
            
            // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut
            let userSession = BehaviorRelay(value: UserSession.loggedOut)
            
            // Subscribe to receive next events from userSession
            userSession
                .subscribe(onNext: { sessionState in
                    print("User status changed to: \(sessionState)")
                })
                .disposed(by: disposeBag)
            
            func logInWith(username: String, password: String, completion: (Error?) -> Void) {
                guard username == "johnny@appleseed.com",
                      password == "appleseed" else {
                    completion(LoginError.invalidCredentials)
                    return
                }
                
                // Update userSession
                userSession.accept(.loggedIn)
                
            }
            
            func logOut() {
                // Update userSession
                userSession.accept(.loggedOut)
                
            }
            
            func performActionRequiringLoggedInUser(_ action: () -> Void) {
                // Ensure that userSession is loggedIn and then execute action()
                if userSession.value == .loggedIn {
                    action()
                }
                
            }
            
            for i in 1...2 {
                let password = i % 2 == 0 ? "appleseed" : "password"
                
                logInWith(username: "johnny@appleseed.com", password: password) { error in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    
                    print("User logged in.")
                }
                
                performActionRequiringLoggedInUser {
                    print("Successfully did something only a logged in user can do.")
                }
            }
        }
    }
}
