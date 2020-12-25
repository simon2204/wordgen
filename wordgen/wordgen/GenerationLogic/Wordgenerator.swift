//
//  Wordgenerator.swift
//  wordgen
//
//  Created by Simon Schöpke on 21.12.20.
//

struct Wordgenerator<Iterator: IteratorProtocol>: Sequence where Iterator.Element == Sign {
    fileprivate let iterator: Iterator
    
    init(iterator: Iterator) {
        self.iterator = iterator
    }
    
    func makeIterator() -> WordgeneratorIterator {
        return WordgeneratorIterator(self)
    }
    
    struct WordgeneratorIterator: IteratorProtocol {
        private var tokenizerIterator: Iterator
        
        fileprivate init(_ wordgenerator: Wordgenerator) {
            self.tokenizerIterator = wordgenerator.iterator
        }
        
        mutating func next() -> String? {
            var word: String = ""
            while let nextSign = tokenizerIterator.next() {
                word = word.isEmpty
                    ? String(nextSign.value!)
                    : word + nextSign.value!
                if nextSign.isEnd {
                    print(word)
                    return word
                }
            }
            return nil
        }
    }
}
