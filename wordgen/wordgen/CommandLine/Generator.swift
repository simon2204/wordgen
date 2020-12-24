//
//  Generator.swift
//  wordgen
//
//  Created by Simon Schöpke on 21.12.20.
//

import ArgumentParser

enum Generator: String, CaseIterable, ExpressibleByArgument {
    case weightedRandom
    case descendingProbability
}
