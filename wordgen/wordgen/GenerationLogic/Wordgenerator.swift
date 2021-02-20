//
//  Wordgenerator.swift
//  wordgen
//
//  Created by Simon Schöpke on 21.12.20.
//

/// Erstellt mit Hilfe eines zu übergebenen `Iterator`s neue Wörter
public struct Wordgenerator<Iterator: IteratorProtocol>: Sequence where Iterator.Element == Sign {
    
    /// `Iterator`, der über die Elemente eines Objektes iterieren kann, welche vom Typ `Sign` sind
    private let iterator: Iterator
    
    public init(iterator: Iterator) {
        self.iterator = iterator
    }
    
    public func makeIterator() -> WordgeneratorIterator {
        return WordgeneratorIterator(self)
    }
    
    /// Iterator für Wordgenerator
    public struct WordgeneratorIterator: IteratorProtocol {
        private var signIterator: Iterator
        
        fileprivate init(_ wordgenerator: Wordgenerator) {
            self.signIterator = wordgenerator.iterator
        }
        
        public mutating func next() -> String? {
            var word: String?
            while let nextSign = signIterator.next(), let nextValue = nextSign.value {
                if (word? += nextValue) == nil {
                    word = String(nextValue)
                }
            }
            return word
        }
    }
}
