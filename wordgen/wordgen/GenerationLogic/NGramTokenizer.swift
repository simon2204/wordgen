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
        createNGramPairsForEachToken(tokens)
    }
    
    private func createNGramPairsForEachToken(_ tokens: [String]) {
        for token in tokens {
            createNgramPairs(token: token)
        }
    }
    
    private func createNgramPairs(token: String) {
        guard token.count >= order else { return }
        let ngramsCount = token.count - order
        addKey(.start, withValue: .value(token[0..<order]))
        for i in 0..<ngramsCount {
            addKey(.value(token[i..<i+order]), withValue: .value(token[i+order]))
        }
        addKey(.value(token[ngramsCount..<ngramsCount+order]), withValue: .end)
    }
    
    private func addKey(_ key: Sign, withValue value: Sign) {
        if transitions[key]?.append(zeichen: value) == nil {
            transitions[key] = Successor(value)
        }
    }
}

extension NGramTokenizer: Codable {}
