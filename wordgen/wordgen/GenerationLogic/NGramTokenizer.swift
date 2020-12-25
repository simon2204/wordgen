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
        let wordLength = token.count
        guard wordLength >= order else { return }
        let ngramCount = wordLength + 1 - order
        let middleCount = wordLength - 1 - order
        if ngramCount == 1 {
            addKey(.`init`, withValue: .end(token[0..<order]))
        } else if ngramCount == 2 {
            addKey(.`init`, withValue: .start(token[0..<order]))
            addKey(.start(token[0..<order]), withValue: .end(token[1..<order+1]))
        } else {
            addKey(.`init`, withValue: .start(token[0..<order]))
            addKey(.start(token[0..<order]), withValue: .middle(token[1..<order+1]))
            for i in 1..<middleCount {
                addKey(.middle(token[i..<order+i]), withValue: .middle(token[i+1..<order+i+1]))
            }
            addKey(.middle(token[middleCount..<order+middleCount]), withValue: .end(token[middleCount+1..<order+middleCount+1]))
        }
    }
    
    private func addKey(_ key: Sign, withValue value: Sign) {
        if transitions[key]?.append(sign: value) == nil {
            transitions[key] = Successor(value)
        }
    }
}

extension NGramTokenizer: Codable {}
