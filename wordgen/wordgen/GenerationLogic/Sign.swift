//
//  Sign.swift
//  NGrams
//
//  Created by Simon Schöpke on 20.12.20.
//

enum Sign: Hashable {
    case `init`
    case start(Substring)
    case middle(Substring)
    case end(Substring)
    
    var isEnd: Bool {
        switch self {
        case .end(_):
            return true
        default:
            return false
        }
    }
    
    var value: Substring? {
        switch self {
        case .`init`:
            return nil
        case let .start(value),
             let .middle(value):
            return value[0]
        case let .end(value):
            return value
        }
    }
    
    var unwrapped: Substring? {
        switch self {
        case .`init`:
            return nil
        case let .start(value),
             let .middle(value),
             let .end(value):
            return value
        }
    }
}

extension Sign: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case base
        case startParam
        case middleParam
        case endParam
    }
    
    private enum Base: String, Codable {
        case `init`
        case start
        case middle
        case end
    }
    
    struct StartParam: Codable {
        let value: String
    }
    
    struct MiddleParam: Codable {
        let value: String
    }
    
    struct EndParam: Codable {
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
        case .middle(let value):
            try container.encode(Base.middle, forKey: .base)
            try container.encode(MiddleParam(value: String(value)), forKey: .middleParam)
        case .end(let value):
            try container.encode(Base.end, forKey: .base)
            try container.encode(MiddleParam(value: String(value)), forKey: .endParam)
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
            self = .middle(Substring(startParam.value))
        case .middle:
            let middleParam = try container.decode(MiddleParam.self, forKey: .middleParam)
            self = .middle(Substring(middleParam.value))
        case .end:
            let endParam = try container.decode(EndParam.self, forKey: .endParam)
            self = .middle(Substring(endParam.value))
        }
    }
}
