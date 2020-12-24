//
//  JsonEncoder.swift
//  wordgen
//
//  Created by Simon Schöpke on 22.12.20.
//

import Foundation
import ArgumentParser

extension Wordgen {
    struct JsonEncoder: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "jsonEncoder",
            abstract: "JsonEncoder for exporting the ngram model.",
            discussion: "Using the JSON model as an input increases import speed significantly",
            helpNames: .short)
        
        @Argument(help: "Path to input-file")
        var input: String
        
        @Argument(help: "Path to output-file")
        var output: String

        @Option(help: "Length of ngrams")
        var order: Int = 3
        
        func validate() throws {
            guard order >= 1 else {
                throw ValidationError("'<order>' must be at least 1.")
            }
        }
        
        func run() throws {
            let data = try Data(contentsOf: URL(fileURLWithPath: input))
            
            guard let encoding = data.stringEncoding else {
                throw CodingError.unknownEncoding
            }
            guard let text = String(data: data, encoding: encoding) else {
                throw CodingError.noPlainText
            }
            
            let tokens = text.components(separatedBy: .whitespacesAndNewlines)
            let tokenizer = NGramTokenizer(tokens: tokens, order: order)
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(tokenizer)
            try jsonData.write(to: URL(fileURLWithPath: output))
        }
    }
}
