//
//  Sign.swift
//  NGrams
//
//  Created by Simon Schöpke on 20.12.20.
//

enum Sign: Hashable {
    case start
    case end
    case value(Substring)
    
    var value: Substring? {
        guard case .value(let substring) = self
        else { return nil }
        return substring
    }
}

extension Sign: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case base
        case valueParam
    }
    
    private enum Base: String, Codable {
        case start
        case end
        case value
    }
    
    struct ValueParam: Codable {
        let ngram: String
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .start:
            try container.encode(Base.start, forKey: .base)
        case .end:
            try container.encode(Base.end, forKey: .base)
        case .value(let ngram):
            try container.encode(Base.value, forKey: .base)
            try container.encode(ValueParam(ngram: String(ngram)), forKey: .valueParam)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        switch base {
        case .start:
            self = .start
        case .end:
            self = .end
        case .value:
            let valueParam = try container.decode(ValueParam.self, forKey: .valueParam)
            self = .value(Substring(valueParam.ngram))
        }
    }
}
