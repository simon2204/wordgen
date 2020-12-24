//
//  WeightedRandomIterator.swift
//  wordgen
//
//  Created by Simon Schöpke on 18.12.20.
//

struct WeightedRandomIterator: IteratorProtocol {
    private let ngramTokenizer: NGramTokenizer
    private var key: Sign = .start
    private var order: Int { ngramTokenizer.order }
    
    init(_ ngramTokenizer: NGramTokenizer) {
        self.ngramTokenizer = ngramTokenizer
    }
    
    mutating func next() -> Sign? {
        return weightedRandom()
    }
    
    private mutating func weightedRandom() -> Sign? {
        guard let successor = ngramTokenizer.transitions[key] else { return nil }
        let successorFrequencyRange = 1...successor.cumulativeFrequency
        let randomNumber = successorFrequencyRange.randomElement()!
        
        var sumOfWeights = 0
        for (newSign, weight) in successor {
            sumOfWeights += weight
            if randomNumber <= sumOfWeights {
                calculateNextKey(from: newSign)
                return newSign
            }
        }
        
        fatalError("This should never be reached")
    }
    
    private mutating func calculateNextKey(from sign: Sign) {
        if key == .start {
            key = sign
        } else if sign == .end {
            key = .start
        } else {
            key = .value(String(key.value!)[1..<order] + sign.value!)
        }
    }
}
