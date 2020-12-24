//
//  String+Subscript.swift
//  NGrams
//
//  Created by Simon Schöpke on 20.12.20.
//

import Foundation

extension String {
    subscript(pos: Int) -> SubSequence {
        return self[pos..<pos+1]
    }
    
    subscript(range: Range<Int>) -> SubSequence {
        let start = self.index(self.startIndex, offsetBy: range.startIndex)
        let ende = self.index(self.startIndex, offsetBy: range.endIndex)
        return self[start..<ende]
    }
}
