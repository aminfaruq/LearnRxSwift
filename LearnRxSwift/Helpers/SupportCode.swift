//
//  SupportCode.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 23/06/25.
//

import Foundation
import RxSwift

public func example(of description: String,
                      action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

// Expanding upon the use of the ternary operator in the previous example, you create a helper function to print the element if there is one, an error if there is one, or else the event itself. How convenient!
public func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(_: label, _: (event.element ?? event.error) ?? event)
}

protocol Runnable {
    func run() throws
}
