//
//  OperatorsCommand.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 26/06/25.
//
import RxSwift
import RxRelay
import Foundation

struct OperatorsCommand: Runnable {
    func run() throws {
        // MARK: - Filtering Operators
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
            
            // create an observable of some predefined integers.
            Observable.of(1,2,3,4,5,6)
            // use the filter operator to apply a conditional constraint to prevent odd numbers from getting through.
                .filter({ $0.isMultiple(of: 2) })
            // subscribe and print out the elements that pass the filter predicate.
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        example(of: "skip") {
            let disposeBag = DisposeBag()
            
            // Create an observable of letters.
            Observable.of("A", "B", "C", "D", "E", "F")
            // Use skip to skip the first 3 elements and subscribe to next events.
                .skip(3)
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        example(of: "skipWhile") {
            let diposeBag = DisposeBag()
            
            // Create an observable of integers.
            Observable.of(2,2,3,4,4)
            // Use skipWhile with a predicate that skips elements until an odd integer is emitted.
                .skip(while: { $0.isMultiple(of: 2) })
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: diposeBag)
        }
        
        example(of: "skipUntil") {
            let disposeBag = DisposeBag()
            
            // Create a subject to model the data you want to work with, and another subject to act as a trigger
            let subject = PublishSubject<String>()
            let trigger = PublishSubject<String>()
            
            // Use skipUntil and pass the trigger subject. When trigger emits, skipUntil stops skipping.
            subject
                .skip(until: trigger)
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            
            // Add a couple of next events onto subject
            subject.onNext("A")
            subject.onNext("B")
            
            // Nothing is printed, because you’re skipping. Now add a new next event onto trigger
            trigger.onNext("X")
            
            // This causes skipUntil to stop skipping. From this point onward, all elements are let through. Add another next event onto subject
            subject.onNext("C")
        }
        
        // MARK: - Taking Operators
        
        example(of: "take") {
            let disposeBag = DisposeBag()
            
            // Create an observable of integers.
            Observable.of(1,2,3,4,5,6)
            // Take the first 3 elements using take.
                .take(3)
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        example(of: "takeWhile") {
            let disposeBag = DisposeBag()
            
            // Create an observable of integers.
            Observable.of(2, 2, 4, 4, 6, 6)
            // Use the enumerated operator to get tuples containing the index and value of each element emitted.
                .enumerated()
            // Use the takeWhile operator, and destructure the tuple into individual arguments.
                .take(while: { index, integer in
                    // Pass a predicate that will take elements until the condition fails.
                    integer.isMultiple(of: 2) && index < 3
                })
            // Use map — which works just like the Swift Standard Library map — to reach into the tuple returned from takeWhile and get the element.
                .map(\.element)
            // Subscribe to and print out next elements.
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        example(of: "takeUntil") {
            let disposeBag = DisposeBag()
            
            // Create an Observable of sequential integers.
            Observable.of(1,2,3,4,5)
            // Use the takeUntil operator with inclusive behavior.
                .take(until: { $0.isMultiple(of: 4) }, behavior: .inclusive)
                // .take(until: { $0.isMultiple(of: 4) }, behavior: .exclusive)
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        example(of: "takeUntil trigger") {
            let disposeBag = DisposeBag()
            
            // Create a primary subject and a trigger subject.
            let subject = PublishSubject<String>()
            let trigger = PublishSubject<String>()
            
            // Use takeUntil, passing the trigger that will cause takeUntil to stop taking once it emits.
            subject
                .take(until: trigger)
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            
            // Add a couple of elements onto subject.
            subject.onNext("1")
            subject.onNext("2")
            
            // Now add an element onto trigger , followed by another element onto subject
            trigger.onNext("X")
            
            subject.onNext("3")
        }
        
        // MARK: - Distinct Operators
        
        example(of: "distinctUntilChanged") {
            let disposeBag = DisposeBag()
            
            // Create an observable of letters.
            Observable.of("A", "A", "B", "B", "A")
            // Use `distinctUntilChanged` to prevent sequential duplicates from getting through.
                .distinctUntilChanged()
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        example(of: "distinctUntilChanged(_:)") {
            let disposeBag = DisposeBag()
            
            // Create a number formatter to spell out each number.
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            
            // Create an observable of NSNumber s instead of Int s, so that you don’t have to convert integers when using the formatter next.
            Observable<NSNumber>.of(10, 110, 20, 200, 210, 310)
            // Use distinctUntilChanged(_:) , which takes a predicate closure that receives each sequential pair of elements.
                .distinctUntilChanged { a, b in
                    // Use guard to conditionally bind the element’s components separated by an empty space, or else return false.
                    guard let aWords = formatter
                        .string(from: a)?
                        .components(separatedBy: " "),
                          let bWords = formatter
                        .string(from: b)?
                        .components(separatedBy: " ")
                    else {
                        return false
                    }
                    
                    var containsMatch = false
                    
                    // Iterate every word in the first array and see if its contained in the second array.
                    for aWord in aWords where bWords.contains(aWord) {
                        containsMatch = true
                        break
                    }
                    
                    return containsMatch
                }
            // Subscribe and print out elements that are considered distinct based on the comparing logic you provided.
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            
        }
        
        example(of: "Sample Not best Practice") {
            let disposeBag = DisposeBag()

            var start = 0
            func getStartNumber() -> Int {
                start += 1
                return start
            }
            
            let numbers = Observable<Int>.create { observer in
                let start = getStartNumber()
                observer.onNext(start)
                observer.onNext(start+1)
                observer.onNext(start+2)
                observer.onCompleted()
                return Disposables.create {}
            }
            
            numbers
                .subscribe(
                    onNext: { el in
                        print("element [\(el)]")
                    },
                    onCompleted: {
                        print("----------")
                    }
                )
                .disposed(by: disposeBag)
        }
    }
}
