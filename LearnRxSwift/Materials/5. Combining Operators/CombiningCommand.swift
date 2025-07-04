//
//  CombiningCommand.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 02/07/25.
//

import Foundation
import RxSwift

struct CombiningCommand: Runnable {
    
    func run() throws {
        
        example(of: "startWith") {
            // Create a sequence of numbers.
            let numbers = Observable.of(2, 3, 4)
            
            // Create a sequence starting with the value 1, then continue with the original sequence of numbers.
            let observable = numbers.startWith(1)
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
        }
        
        example(of: "Observable.concat") {
            let bag = DisposeBag()
            
            // 1
            let first = Observable.of(1, 2, 3)
            let second = Observable.of(4, 5, 6)
            
            // 2
            let observable = Observable.concat([first, second])
            
            observable.subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: bag)
        }
        
        example(of: "concat") {
            let bag = DisposeBag()

            let germanCities = Observable.of("Berlin", "Münich", "Frankfurt")
            let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")
            
            let observable = germanCities.concat(spanishCities)
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: bag)
        }
        
        example(of: "concatMap") {
            let bag = DisposeBag()

            // Prepares two sequences producing German and Spanish city names.
            let sequences = [
                "German cities": Observable.of("Berlin", "Münich", "Frankfurt"),
                "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")
            ]
            
            // Has a sequence emit country names, each in turn mapping to a sequence emitting city names for this country.
            let observable = Observable.of("German cities", "Spanish cities")
                .concatMap({ country in sequences[country] ?? .empty() })
            
            // Outputs the full sequence for a given country before starting to consider the next one.
            _ = observable.subscribe(onNext: { string in
                print(string)
            })
            .disposed(by: bag)
        }
        
        example(of: "merge") {
            let bag = DisposeBag()

            // Next, create a source observable of observables — it’s like Inception! To keep things simple, make it a fixed list of your two subjects
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            
            // Create a merge observable from the two subjects, as well as a subscription to print the values it emits
            let source = Observable.of(left.asObservable(), right.asObservable())
            
            // Then you need to randomly pick and push values to either observable. The loop uses up all values from leftValues and rightValues arrays then exits.
            let observable = source.merge()
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: bag)
            
            // Then you need to randomly pick and push values to either observable.
            var leftValues = ["Berlin", "Munich", "Frankfurt"]
            var rightValues = ["Madrid", "Barcelona", "Valencia"]
            repeat {
                switch Bool.random() {
                case true where !leftValues.isEmpty:
                    left.onNext("Left: " + leftValues.removeFirst())
                case false where !rightValues.isEmpty:
                    right.onNext("Right: " + rightValues.removeFirst())
                default:
                    break
                }
                
            } while !leftValues.isEmpty || !rightValues.isEmpty
            
            // One last bit before you’re done is calling
            left.onCompleted()
            right.onCompleted()
        }
        
        example(of: "combineLatest") {
            // create two subjects to push values to
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            
            // create an observable that combines the latest value from both sources. Don’t worry; you’ll understand how the code exactly works once you’ve finished adding everything together
            let observable = Observable.combineLatest(left, right) { lastLeft, lastRight in
                return "\(lastLeft) \(lastRight)"
            }
            
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
            
            // Finally, don’t forget to complete both of your subjects and close the `example(of:)` trailing closure:
            print("> Sending a value to Left")
            left.onNext("Hello,")
            print("> Sending a value to Right")
            right.onNext("world")
            print("> Sending another value to Right")
            right.onNext("RxSwift")
            print("> Sending another value to Left")
            left.onNext("Have a good day,")
            
            left.onCompleted()
            right.onCompleted()
        }
        
        example(of: "combine user choice and value") {
            let choice: Observable<DateFormatter.Style> = Observable.of(.short, .long)
            let dates = Observable.of(Date())
            
            let observable = Observable.combineLatest(choice, dates) { format, when -> String in
                let formatter = DateFormatter()
                formatter.dateStyle = format
                return formatter.string(from: when)
            }
            
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
        }
        
        example(of: "zip") {
            enum Weather {
                case cloudy
                case sunny
            }
            
            let left: Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
            let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")
            
            let observable = Observable.zip(left, right) { weather, city in
                return "It's \(weather) in \(city)"
            }
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
        }
        
        example(of: "withLatestFrom") {
            // Create two subjects simulating button taps and text field input. Since the button carries no real data, you can use Void as an element type.
            let button = PublishSubject<Void>()
            let textField = PublishSubject<String>()
            
            // When button emits a value, ignore it but instead emit the latest value received from the simulated text field.
            let observable = button.withLatestFrom(textField)
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
            
            // Simulate successive inputs to the text field, which is done by the two successive button taps.
            textField.onNext("par")
            textField.onNext("pari")
            textField.onNext("paris")
            button.onNext(())
            button.onNext(())
        }
        
        example(of: "amb") {
            let left = PublishSubject<String>()
            let right = PublishSubject<String>()
            
            // Create an observable which resolves ambiguity between left and right.
            let observable = left.amb(right)
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
            
            // Have both observables send data.
            left.onNext("Lisbon")
            right.onNext("Copenhagen")
            left.onNext("London")
            left.onNext("Madrid")
            right.onNext("Vienna")
            
            left.onCompleted()
            right.onCompleted()
        }
        
        example(of: "switchLatest") {
            // first create three subjects and a source subject
            let one = PublishSubject<String>()
            let two = PublishSubject<String>()
            let three = PublishSubject<String>()
            
            let source = PublishSubject<Observable<String>>()
            
            // Next, create an observable with the switchLatest() operator and print its output.
            let observable = source.switchLatest()
            let disposable = observable.subscribe(onNext: { value in
                print(value)
            })
            
            // Start feeding the source with observables, and feed observables with values.
            source.onNext(one)
            one.onNext("Some text from sequence one")
            two.onNext("Some text from sequence two")
            
            source.onNext(two)
            two.onNext("More text from sequence two")
            one.onNext("an also from sequence one")
            
            source.onNext(three)
            two.onNext("Why don't you see me?")
            one.onNext("I'm alone, help me")
            three.onNext("Hey it's three. I win.")
            
            source.onNext(one)
            one.onNext("Nope. It's me, one!")
            
            // Finally dispose the subscription when you‘re done.
            disposable.dispose()
        }
        
        example(of: "reduce") {
            let source = Observable.of(1, 3, 5, 7, 9)
            
            // 1
            let observable = source.reduce(0, accumulator: +)
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
        }
        
        example(of: "scan") {
            let source = Observable.of(1, 3, 5, 7, 9)
            
            let observable = source.scan(0, accumulator: +)
            _ = observable.subscribe(onNext: { value in
                print(value)
            })
        }
    }
}
