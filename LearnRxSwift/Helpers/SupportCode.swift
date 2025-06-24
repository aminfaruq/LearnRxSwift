//
//  SupportCode.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 23/06/25.
//

import Foundation

public func example(of description: String,
                      action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}

protocol Runnable {
    func run() throws
}
