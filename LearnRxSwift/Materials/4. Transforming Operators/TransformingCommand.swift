//
//  TransformingCommand.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 30/06/25.
//

import Foundation
import RxSwift

struct TransformingCommand: Runnable {
    struct Student {
        let score: BehaviorSubject<Int>
    }
    
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
        
        example(of: "map") {
            let disposeBag = DisposeBag()
            
            // You create a number formatter to spell out each number.
            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            
            // You create an observable of Int.
            Observable<Int>.of(123, 4, 56)
            // You use map , passing a closure that gets and returns the result of using the formatter to return the number’s spelled out string — or an empty string if that operation returns nil .
                .map({
                    formatter.string(for: $0) ?? ""
                })
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        example(of: "enumerated and map") {
            let disposeBag = DisposeBag()
            
            // Create an observable of integers.
            Observable.of(1,2,3,4,5,6)
            // Use enumerated to produce tuple pairs of each element and its index.
                .enumerated()
            // Use map , and destructure the tuple into individual arguments. If the element’s index is greater than 2 , multiply it by 2 and return it; else, return it as-is.
                .map({ index, integer in
                    index > 2 ? integer * 2 : integer
                })
            // Subscribe and print elements as they’re emitted.
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        example(of: "compactMap") {
            let disposeBag = DisposeBag()
            
            // Create an observable of String? , which the of operator infers from the values.
            Observable.of("To", "be", nil, "or", "not", "to", "be", nil)
            // Use the compactMap operator to retrieve unwrapped value, and filter out nil s.
                .compactMap({ $0 })
            // Use toArray to convert the observable into a Single that emits an array of all its values.
                .toArray()
            // Use map to join the values together, separated by a space.
                .map({ $0.joined(separator: " ") })
            // Print the result in the subscription.
                .subscribe(onSuccess: {
                    print($0)
                })
                .disposed(by: disposeBag)
        }
        
        example(of: "flatMap") {
            let disposeBag = DisposeBag()
            
            //  create two instances of Student , laura and charlotte.
            let laura = Student(score: BehaviorSubject(value: 80))
            let charlotte = Student(score: BehaviorSubject(value: 90))
            
            // create a source subject of type Student.
            let student = PublishSubject<Student>()
            
            // use flatMap to reach into the student subject and project its score.
            student
                .flatMap({
                    $0.score
                })
            // print out next event elements in the subscription.
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            
            student.onNext(laura)
            laura.score.onNext(85)
            
            student.onNext(charlotte)
            laura.score.onNext(95)
            charlotte.score.onNext(100)
        }
        
        example(of: "flatMapLatest") {
            let disposeBag = DisposeBag()
            
            let laura = Student(score: BehaviorSubject(value: 80))
            let charlotte = Student(score: BehaviorSubject(value: 90))
            
            let student = PublishSubject<Student>()
            
            student
                .flatMapLatest({
                    $0.score
                })
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            
            student.onNext(laura)
            laura.score.onNext(85)
            student.onNext(charlotte)
            
            // Changing laura ’s score here will have no effect. It will not be printed out. This is because flatMapLatest switched to the latest observable, for charlotte :
            laura.score.onNext(95)
            charlotte.score.onNext(100)
        }
        
        example(of: "materialize and dematerialize") {
            // Create an error type.
            enum MyError: Error {
                case anError
            }
            
            let disposeBag = DisposeBag()
            
            // Create two instances of Student and a student behavior subject with the first student laura as its initial value.
            let laura = Student(score: BehaviorSubject(value: 80))
            let charlotte = Student(score: BehaviorSubject(value: 100))
            
            let student = BehaviorSubject(value: laura)
            
            // Create a studentScore observable using flatMapLatest to reach into the student observable and access its score observable property.
            let studentScore = student
            //.flatMapLatest({
            //   $0.score
            //})
                .flatMapLatest({
                    $0.score.materialize()
                })
            
            // Subscribe to and print out each score when it is emitted.
            studentScore
            // Print and filter out any errors.
                .filter({
                    guard $0.error == nil else {
                        print($0.error!)
                        return false
                    }
                    
                    return true
                })
            // Use dematerialize to return the studentScore observable to its original form, emitting scores and stop events, not events of scores and stop events.
                .dematerialize()
                .subscribe(onNext: {
                    print($0)
                })
                .disposed(by: disposeBag)
            
            // Add a score, error, and another score onto the current student.
            laura.score.onNext(85)
            
            laura.score.onError(MyError.anError)
            
            laura.score.onNext(90)
            
            // Add the second student charlotte onto the student observable. Because you used flatMapLatest , this will switch to this new student and subscribe to her score.
            student.onNext(charlotte)
        }
    }
}
