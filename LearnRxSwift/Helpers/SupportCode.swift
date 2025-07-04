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

public let cards = [
  ("🂡", 11), ("🂢", 2), ("🂣", 3), ("🂤", 4), ("🂥", 5), ("🂦", 6), ("🂧", 7), ("🂨", 8), ("🂩", 9), ("🂪", 10), ("🂫", 10), ("🂭", 10), ("🂮", 10),
  ("🂱", 11), ("🂲", 2), ("🂳", 3), ("🂴", 4), ("🂵", 5), ("🂶", 6), ("🂷", 7), ("🂸", 8), ("🂹", 9), ("🂺", 10), ("🂻", 10), ("🂽", 10), ("🂾", 10),
  ("🃁", 11), ("🃂", 2), ("🃃", 3), ("🃄", 4), ("🃅", 5), ("🃆", 6), ("🃇", 7), ("🃈", 8), ("🃉", 9), ("🃊", 10), ("🃋", 10), ("🃍", 10), ("🃎", 10),
  ("🃑", 11), ("🃒", 2), ("🃓", 3), ("🃔", 4), ("🃕", 5), ("🃖", 6), ("🃗", 7), ("🃘", 8), ("🃙", 9), ("🃚", 10), ("🃛", 10), ("🃝", 10), ("🃞", 10)
]

public func cardString(for hand: [(String, Int)]) -> String {
  return hand.map { $0.0 }.joined(separator: "")
}

public func points(for hand: [(String, Int)]) -> Int {
  return hand.map { $0.1 }.reduce(0, +)
}

public enum HandError: Error {
  case busted(points: Int)
}

public class Example {
    public static var beforeEach: ((String) -> ())? = nil

    public static func of(_ description: String, action: () -> ()) {
        beforeEach?(description)
        printHeader(description)
        action()
    }

    private static func printHeader(_ message: String) {
        print("\nℹ️ \(message):")
        let length = Float(message.count + 3) * 1.2
        print(String(repeating: "—", count: Int(length)))
    }
}
