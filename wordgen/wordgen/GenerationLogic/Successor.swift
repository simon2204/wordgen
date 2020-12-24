//
//  Successor.swift
//  wordgen
//
//  Created by Simon Schöpke on 20.12.20.
//

struct Successor {
    private var dict = [Sign: Int]()
    private(set) var cumulativeFrequency = 0
    
    init(_ sign: Sign) {
        append(zeichen: sign)
    }
    
    mutating func append(zeichen: Sign) {
        if (dict[zeichen]? += 1) == nil {
            dict[zeichen] = 1
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
