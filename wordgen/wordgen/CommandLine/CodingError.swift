//
//  CodingError.swift
//  wordgen
//
//  Created by Simon Schöpke on 22.12.20.
//

enum CodingError: Error {
    case unknownEncoding
    case noPlainText
    case unableToWrite(forEncoding: String.Encoding)
}
