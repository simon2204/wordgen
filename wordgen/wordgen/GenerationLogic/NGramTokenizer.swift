//
//  NGramTokenizer.swift
//  wordgen
//
//  Created by Simon Schöpke on 20.12.20.
//

final class NGramTokenizer {
    let order: Int
    private(set) var transitions = [Sign: Successor]()
    
    init(tokens: [String], order: Int) {
        self.order = order
        createNGramPairs(for: tokens)
    }
    
    private func createNGramPairs(for tokens: [String]) {
        for token in tokens {
            createNgramPairs(for: token)
        }
    }
    
    private func createNgramPairs(for token: String) {
        let wordLength = token.count
        guard wordLength >= order else { return }
        let ngramCount = wordLength + 1 - order
        addKey(.`init`, withValue: .start(token[0..<order]))
        var key = Sign.start(token[0..<order])
        for i in 1..<ngramCount {
            addKey(key, withValue: .value(token[i..<i+order]))
            key = .value(token[i..<i+order])
        }
        addKey(key, withValue: .end)
    }
    
    private func addKey(_ key: Sign, withValue value: Sign) {
        if transitions[key]?.append(sign: value) == nil {
            transitions[key] = Successor(value)
        }
    }
}

extension NGramTokenizer: Codable {}
