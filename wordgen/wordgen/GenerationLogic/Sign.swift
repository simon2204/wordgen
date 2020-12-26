//
//  Sign.swift
//  NGrams
//
//  Created by Simon Schöpke on 20.12.20.
//

enum Sign: Hashable {
    case `init`
    case start(Substring)
    case value(Substring)
    case end
    
    var value: Substring? {
        switch self {
        case .`init`, .end:
            return nil
        case let .start(value):
            return value
        case let .value(value):
            return value[value.index(before: value.endIndex)]
        }
    }
}

extension Sign: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case base
        case startParam
        case valueParam
    }
    
    private enum Base: String, Codable {
        case `init`
        case start
        case value
        case end
    }
    
    struct StartParam: Codable {
        let value: String
    }
    
    struct ValueParam: Codable {
        let value: String
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case.`init`:
            try container.encode(Base.`init`, forKey: .base)
        case .start(let value):
            try container.encode(Base.start, forKey: .base)
            try container.encode(StartParam(value: String(value)), forKey: .startParam)
        case .value(let value):
            try container.encode(Base.value, forKey: .base)
            try container.encode(ValueParam(value: String(value)), forKey: .valueParam)
        case .end:
            try container.encode(Base.end, forKey: .base)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        switch base {
        case .`init`:
            self = .`init`
        case .start:
            let startParam = try container.decode(StartParam.self, forKey: .startParam)
            self = .start(Substring(startParam.value))
        case .value:
            let middleParam = try container.decode(ValueParam.self, forKey: .valueParam)
            self = .value(Substring(middleParam.value))
        case .end:
            self = .end
        }
    }
}
