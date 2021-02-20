//
//  NGramTokenizer.swift
//  wordgen
//
//  Created by Simon Schöpke on 20.12.20.
//

/// Zerlegt `String`s in Fragmente. Dabei werden jeweils *N* aufeinanderfolgende Fragmente als *N-Gramm* zusammengefasst.
public final class NGramTokenizer {
    
    /// Beschreibt das Level eines N-Gramms.
    /// Z.B. nennt man ein N-Gramm mit einem Level von 2 Bigramm oder ein N-Gramm mit einem Level von 3 Trigramm.
    internal let order: Int
    
    /// Alle Transitionen von einem `Sign` zum nächsten, wobei ein `Sign` oft mehrere Nachfolger hat.
    /// Die Nachfolger befinden sich deshalb in `Successor`
    private(set) internal var transitions = [Sign: Successor]()
    
    /// Erstellt einen neuen NGramTokenizer
    /// - Parameters:
    ///   - tokens: Die Wörter, die unterteilt werden sollen
    ///   - order: Das Level, der N-Gramms
    public init(tokens: [String], order: Int) {
        self.order = order
        createNGramPairsForEachToken(tokens)
    }
    
    /// Erzeugt für alle `tokens` N-Gramm Paare
    /// - Parameter tokens: Die Wörter, aus denen die N-Gramms entstehen
    private func createNGramPairsForEachToken(_ tokens: [String]) {
        for token in tokens {
            createNgramPairs(token: token)
        }
    }
    
    /// Erzeugt für ein einzelnes Token N-Gramm Paare
    /// - Parameter token: Das Wort, aus denen die N-Gramms entstehen
    private func createNgramPairs(token: String) {
        let wordLength = token.count
        
        // Wörter die kürzer sind als `order` sollen ignoriert werden
        guard wordLength >= order else { return }
        
        // Anzahl der N-Gramme die durch `token` erzeugt werden können
        let ngramCount = wordLength + 1 - order
        
        // Das `startNGram` welches bei Index 0 beginnt und bei `order` - 1 ended
        let startNGram = Sign.start(token[0..<order])
        
        // `Sign.init` zeigt immer auf das "Start N-Gramm"
        addKey(.`init`, withValue: startNGram)
        
        var currentNGram = startNGram
        
        var newNGram: Sign
        
        for i in 1..<ngramCount {
            newNGram = .value(token[i..<i+order])
            addKey(currentNGram, withValue: newNGram)
            currentNGram = newNGram
        }
        
        // Das letzte N-Gram wird mit `Sign.end` gekennzeichnet
        addKey(currentNGram, withValue: .end)
    }
    
    /// Fügt einen neuen `Successor` zu den `transitions` hinzu.
    /// - Parameters:
    ///   - key: Der Schlüssel des `Successor`s
    ///   - value: Der Wert, der als `Successor` gepeichert wird
    private func addKey(_ key: Sign, withValue value: Sign) {
        if transitions[key]?.append(sign: value) == nil {
            transitions[key] = Successor(value)
        }
    }
}

extension NGramTokenizer: Codable {}
