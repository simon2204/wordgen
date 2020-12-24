//
//  NaiveDescendingProbabilityIterator.swift
//  Ngrams
//
//  Created by Simon Schöpke on 19.12.20.
//

struct NaiveDescendingProbabilityIterator: IteratorProtocol {
    private let ngramTokenizer: NGramTokenizer
    private let maxWordCount: Int
    private var orderedSuccessors = [Sign : [Sign]]()
    private var nextSigns: [(Sign, Int)] = [(.start, 0)]
    private var currentIndex = 0
    
    private var order: Int {
        ngramTokenizer.order
    }
    
    init(_ ngramTokenizer: NGramTokenizer, maxWordCount: Int) {
        self.ngramTokenizer = ngramTokenizer
        self.maxWordCount = maxWordCount + 1 - ngramTokenizer.order
        orderedSuccessors.reserveCapacity(ngramTokenizer.transitions.count)
        nextSigns.reserveCapacity(maxWordCount)
    }
    
    
    mutating func next() -> Sign? {
        guard fillUpNextSigns() else { return nil }
        var nextSign: Sign = .end
        
        if currentIndex < nextSigns.count {
            let (sign, index) = nextSigns[currentIndex]
            nextSign = successors(for: sign)![index]
            currentIndex += 1
        }
        if nextSign == .end {
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
        while nextSigns.count < maxWordCount {
            guard let (element, index) = nextSigns.last else { return false }
            var nextSign = successors(for: element)![index]
            if element == .start {
                nextSigns.append((nextSign, 0))
            } else if let nextValue = nextSign.value {
                nextSign = .value(String(element.value!)[1..<order] + nextValue)
                nextSigns.append((nextSign, 0))
            } else {
                return true
            }
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
