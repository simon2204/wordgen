//
//  main.swift
//  wordgen
//
//  Created by Simon Schöpke on 23.12.20.
//

import ArgumentParser

struct Wordgen: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "wordgen",
        abstract: "A word generator generating words",
        subcommands: [MarkovGenerator.self, JsonEncoder.self],
        defaultSubcommand: MarkovGenerator.self,
        helpNames: .shortAndLong)
}

Wordgen.main()

