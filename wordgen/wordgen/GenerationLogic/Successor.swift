//
//  Successor.swift
//  wordgen
//
//  Created by Simon Schöpke on 20.12.20.
//

/// Ansammlung von zugehörigen `Sign`s, die auf ein bestimmtes `Sign` gefolgt sind
internal struct Successor {
    
    /// Enthält alle Nachfolger eines vorherigen, gemeinsamen `Sign`s
    /// und die Anzahl der jeweiligen Vorkommen
    private var dict = [Sign: Int]()
    
    /// Die Aufsummierung der Anzahl aller Vorkommen, die es in `dict` gibt
    private(set) var cumulativeFrequency = 0
    
    /// Initialisiert `Successor` mit einem `sign`
    /// - Parameter sign: Nachfolger eines vorangegangenen `Sign`s
    init(_ sign: Sign) {
        append(sign: sign)
    }
    
    /// Fügt ein neues `sign` hinzu und inkrementiert die Anzahl der Vorkommen
    /// - Parameter sign: Das zu hinzufügende `sign`
    mutating func append(sign: Sign) {
        if (dict[sign]? += 1) == nil {
            dict[sign] = 1
        }
        cumulativeFrequency += 1
    }
}

extension Successor: Sequence {
    func makeIterator() -> Dictionary<Sign, Int>.Iterator {
        dict.makeIterator()
    }
}

extension Successor: Codable {}
