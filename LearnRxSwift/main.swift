//
//  main.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 23/06/25.
//
import Foundation
import RxSwift

// MARK: - Creating Observables

example(of: "just, of, from") {
    // First, let's make some numbers to play with.
    let one = 1
    let two = 2
    let three = 3

    // --- Ways to create simple observables ---

    // 'just' creates an observable sequence with exactly one element.
    let observable = Observable<Int>.just(one)

    // 'of' creates an observable sequence with a fixed number of elements.
    let observable2 = Observable.of(one, two, three)

    // 'of' can also take an array, but it emits the entire array as a single element.
    let observable3 = Observable.of([one, two, three])

    // 'from' creates an observable sequence from a collection, like an array. It emits each item individually.
    let observable4 = Observable.from([one, two, three])
}

// MARK: - Subscribing to Observables

example(of: "subscribe") {
    // Create an observable that will emit 1, 2, and 3.
    let one = 1
    let two = 2
    let three = 3
    let observable = Observable.of(one, two, three)

    /*
     This is one way to subscribe. The 'event' can be .next(value), .error(error), or .completed.
     You have to check what kind of event it is.
     
     observable.subscribe { event in
         if let element = event.element {
             print(element)
         }
     }
     */
    
    // A more common way to subscribe is by providing closures for each event type you care about.
    // Here, we only care about the 'next' event, which contains an element.
    observable.subscribe(onNext: { element in
        print(element)
    }).dispose() // We call dispose() here for the example, to immediately clean up.
}

example(of: "empty") {
    // 'empty' creates an observable that sends no elements and immediately sends a 'completed' event.
    let observable = Observable<Void>.empty()
    
    observable.subscribe(
        // This 'onNext' block will never be called because there are no elements.
        onNext: { element in
            print(element)
        },
        // This 'onCompleted' block will be called right away.
        onCompleted: {
            print("Completed")
        }
    ).dispose()
}

example(of: "never") {
    // 'never' creates an observable that sends no elements and never finishes. It just sits there silently.
    let observable = Observable<Void>.never()
    
    // Because the 'never' observable does nothing, none of these blocks will ever be called.
    observable.subscribe(
        onNext: { element in
            print(element)
        },
        onCompleted: {
            print("Completed")
        }
    ).dispose()
}

example(of: "range") {
    // 1. Create an observable that emits a sequence of integers, starting from 1 and emitting 10 numbers total.
    let observable = Observable<Int>.range(start: 1, count: 10)
    
    observable
        .subscribe(onNext: { i in
            // 2. For each number 'i' that the range emits, we'll do some math.
            // This calculates the nth Fibonacci number.
            let n = Double(i)
            let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
            print(fibonacci)
        }
    ).dispose()
}

// MARK: - Managing Memory (Disposing)

example(of: "dispose") {
    // 1. Create an observable that will emit three letters.
    let observable = Observable.of("A", "B", "C")
    
    // 2. Subscribe to the observable and save the returned 'Disposable' (the subscription itself).
    let subscription = observable.subscribe { event in
        // 3. This block runs for every event the observable sends.
        print(event)
    }
    
    // 4. Manually cancel the subscription. This is important to free up memory.
    subscription.dispose()
}

example(of: "DisposeBag") {
    // 1. Create a DisposeBag. Think of it as a trash can for your subscriptions.
    let disposeBag = DisposeBag()
    
    // 2. Create an observable.
    Observable.of("A", "B", "C")
        // 3. Subscribe to the observable. '$0' is just a shorthand for the event.
        .subscribe {
            print($0)
        }
        // 4. Add the subscription to the disposeBag. The bag will automatically call .dispose() on it
        //    when the bag itself is deallocated (e.g., when a view controller is dismissed).
        .disposed(by: disposeBag)
}

// MARK: - Advanced Creation

example(of: "create") {
    // An enum to represent a custom error.
    enum MyError: Error {
        case anError
    }
    
    // Use a DisposeBag for good memory management.
    let disposeBag = DisposeBag()
    
    // 'create' lets you define an observable's behavior completely.
    Observable<String>.create { observer in
        // 1. Send a 'next' event. Subscribers will receive "1".
        observer.onNext("1")
        
        // Send an 'error' event. This immediately stops the observable sequence.
        observer.onError(MyError.anError)
        
        // 2. This line will NOT be reached because the observable already terminated with an error.
        observer.onCompleted()
        
        // 3. THIS LINE WILL NEVER BE EXECUTED.
        observer.onNext("?")
        
        // 4. A 'create' closure must always return a disposable, which handles cleanup.
        return Disposables.create()
    }
    .subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") }
    )
    .disposed(by: disposeBag)
}

example(of: "deferred") {
    let disposeBag = DisposeBag()
    
    // 1. Create a boolean "switch" that we can flip.
    var flip = false
    
    // 2. Create a "deferred" observable. The code inside this block only runs when a new observer subscribes.
    let factory: Observable<Int> = Observable.deferred {
        
        // 3. Every time a new subscription starts, flip the switch.
        flip.toggle()
        
        // 4. Based on the switch, create and return a different observable.
        if flip {
            return Observable.of(1, 2, 3)
        } else {
            return Observable.of(4, 5, 6)
        }
    }
    
    // Subscribe four times to see how the output changes each time.
    for _ in 0...3 {
        factory.subscribe(onNext: {
            // Print the numbers without a new line.
            print($0, terminator: "")
        })
        .disposed(by: disposeBag)
        
        // Print a new line to separate the output of each subscription.
        print()
    }
}

example(of: "Single") {
    // 1. Create a dispose bag to use later.
    let disposeBag = DisposeBag()
    
    // 2. Define an `Error` enum to model some possible errors that can occur in reading data from a file on disk.
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    
    // 3. Implement a function to load text from a file on disk that returns a Single.
    func loadText(from name: String) -> Single<String> {
        //4. Create and return a Single.
        return Single.create { single in
            // Create a Disposable , because the subscribe closure of create expects it as its return type.
            let disposable = Disposables.create()
            
            // Get the path for the filename, or else add a file not found error onto the Single and return the disposable you created.
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.failure(FileReadError.fileNotFound))
                return disposable
            }
            
            // Get the data from the file at that path, or add an unreadable error onto the Single and return the disposable.
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.failure(FileReadError.unreadable))
                return disposable
            }
          
            // Convert the data to a string; otherwise, add an encoding failed error onto the Singleand return the disposable. Starting to see a pattern here?
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.failure(FileReadError.encodingFailed))
                return disposable
            }
            
            // Made it this far? Add the contents onto the Single as a success, and return the disposable.
            single(.success(contents))
            return disposable
        }
    }
    // Call loadText(from:) and pass the root name of the text file.
    loadText(from: "Copyright")
    // Subscribe to the Single it returns.
        .subscribe {
            // Switch on the event and print the string if it was successful, or print the error if not.
            switch $0 {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }
        .disposed(by: disposeBag)
}
