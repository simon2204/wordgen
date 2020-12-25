//
//  NaiveDescendingProbabilityIterator.swift
//  Ngrams
//
//  Created by Simon Schöpke on 19.12.20.
//

struct NaiveDescendingProbabilityIterator: IteratorProtocol {
    private let ngramTokenizer: NGramTokenizer
    private let maxWordLength: Int
    private var orderedSuccessors = [Sign : [Sign]]()
    private var nextSigns = [(Sign.`init`, 0)]
    private var currentIndex = 0
    
    private var order: Int {
        ngramTokenizer.order
    }
    
    init(_ ngramTokenizer: NGramTokenizer, maxWordLength: Int) {
        self.ngramTokenizer = ngramTokenizer
        self.maxWordLength = maxWordLength + 1 - ngramTokenizer.order
        orderedSuccessors.reserveCapacity(ngramTokenizer.transitions.count)
        nextSigns.reserveCapacity(maxWordLength)
    }
    
    
    mutating func next() -> Sign? {
        guard fillUpNextSigns() else { return nil }
        let (sign, index) = nextSigns[currentIndex]
        var nextSign = successors(for: sign)![index]
        
        if currentIndex == maxWordLength - 1 {
            nextSign = .end(nextSign.unwrapped!)
        }
        
        currentIndex += 1
        
        if nextSign.isEnd {
            currentIndex = 0
            nextPermutation()
        }
        
        return nextSign
    }
    
    
    private mutating func successors(for sign: Sign) -> [Sign]? {
        if let signs = orderedSuccessors[sign] { return signs }
        guard let successor = ngramTokenizer.transitions[sign] else { return nil }
        let orderedSigns = successor.lazy.sorted(by: { $0.1 > $1.1 }).map(\.key)
        orderedSuccessors[sign] = orderedSigns
        return orderedSigns
    }
    
    
    private mutating func fillUpNextSigns() -> Bool {
        while nextSigns.count < maxWordLength {
            guard let (element, index) = nextSigns.last else { return false }
            let nextSign = successors(for: element)![index]
            if nextSign.isEnd { return true }
            nextSigns.append((nextSign, 0))
        }
        return true
    }
    
    
    private mutating func nextPermutation() {
        guard var (lastElement, index) = nextSigns.last else { return }
        var successorCount = self.successors(for: lastElement)!.count

        while index == successorCount - 1 {
            nextSigns.removeLast()
            guard let lastSign = nextSigns.last else { return }
            (lastElement, index) = lastSign
            successorCount = self.successors(for: lastElement)!.count
        }

        nextSigns[nextSigns.count - 1] = (lastElement, index + 1)
    }
}
