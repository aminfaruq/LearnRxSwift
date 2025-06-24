//
//  main.swift
//  LearnRxSwift
//
//  Created by Amin faruq on 23/06/25.
//

import Foundation

// An array of all the commands your tool can run.
let commands: [Runnable] = [
//    ObservablesCommand(),
    SubjectsCommand()
]

// A simple function to run all registered commands.
func runAllCommands() {
    for command in commands {
        do {
            try command.run()
        } catch {
            print("An error occurred: \(error)")
        }
    }
}

runAllCommands()
