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
        let ngramCount = token.count + 1 - order
        if ngramCount == 1 {
            addKey(.`init`, withValue: .end(token[0..<order]))
        } else if ngramCount == 2 {
            addKey(.`init`, withValue: .start(token[0..<order]))
            addKey(.start(token[0..<order]), withValue: .end(token[1..<order+1]))
        } else {
            addKey(.`init`, withValue: .start(token[0..<order]))
            addKey(.start(token[0..<order]), withValue: .middle(token[1..<order+1]))
            for i in 1..<ngramCount-1 {
                addKey(.middle(token[i..<order+i]), withValue: .middle(token[i+1..<order+i+1]))
            }
            addKey(.middle(token[ngramCount-1..<order+ngramCount-1]), withValue: .end(token[ngramCount..<order+ngramCount]))
        }
    }
    
    private func addKey(_ key: Sign, withValue value: Sign) {
        if transitions[key]?.append(sign: value) == nil {
            transitions[key] = Successor(value)
        }
    }
}

extension NGramTokenizer: Codable {}
