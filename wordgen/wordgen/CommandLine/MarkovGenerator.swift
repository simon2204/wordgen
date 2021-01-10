//
//  MarkovGenerator.swift
//  wordgen
//
//  Created by Simon Schöpke on 22.12.20.
//

import Foundation
import ArgumentParser

extension Wordgen {
    struct MarkovGenerator: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "generator",
            abstract: "Generating words based on ngram length and on generator mode.",
            helpNames: .short)
        
        @Flag(name: [.customShort("j"), .customLong("json", withSingleDash: false)],
              help: "Input from JSON model.")
        var isJsonModel = false
        
        @Argument(help: "Path to input-file. (When using plain text, each word should be seperated by a newline)")
        var input: String
        
        @Argument(help: "Path to output-file.")
        var output: String
        
        @Option(name: .shortAndLong,
                help: "The mode to run the generator in. Either 'weightedRandom' or 'descendingProbability'.")
        var generator: Generator
        
        @Option(name: .shortAndLong,
                help: "Count of words to be returned, up to the specified maximum.")
        var count: Int
        
        @Option(name: .shortAndLong,
                help: "Length of ngrams. (This Options has no effect when importing a JSON file)")
        var order: Int?
        
        @Option(name: .shortAndLong,
                help: "Max word length to be returned. (This Options has no effect when using WeightedRandomGenerator)")
        var wordLength: Int?
        
        @Option(name: .shortAndLong,
                help: "The seperator by which the words should be seperated. (Outputfile)")
        var seperator: String?
        
        func validate() throws {
            guard count >= 0 else {
                throw ValidationError("'<count>' must be at least 0.")
            }
            
            if !isJsonModel {
                guard let order = order else {
                    throw ValidationError("Missing expected argument '--order <order>'. Has to be provided when input-file is no JSON model.")
                }
                
                guard order >= 1 else {
                    throw ValidationError("'<order>' has to be at least 1.")
                }
            }
            
            if generator == .descendingProbability {
                guard let wordLength = wordLength else {
                    throw ValidationError("Missing expected argument '--wordLength <wordLength>'. Has to be provided when using DescendingProbabilityGenerator.")
                }
                
                guard wordLength >= 1 else {
                    throw ValidationError("'<wordLength>' has to be at least 1.")
                }
            }
        }
        
        func run() throws {
            let url = URL(fileURLWithPath: input)
            let inputData = try Data(contentsOf: url)
            
            let tokenizer: NGramTokenizer
            var outputEncoding: String.Encoding = .utf8
            
            if isJsonModel {
                let jsonDecoder = JSONDecoder()
                tokenizer = try jsonDecoder.decode(NGramTokenizer.self, from: inputData)
            } else {
                guard let encoding = inputData.stringEncoding else {
                    throw CodingError.unknownEncoding
                }
                guard let text = String(data: inputData, encoding: encoding) else {
                    throw CodingError.noPlainText
                }
                let tokens = text.components(separatedBy: .whitespacesAndNewlines)
                tokenizer = NGramTokenizer(tokens: tokens, order: order!)
                outputEncoding = encoding
            }
            
            switch generator {
            case .weightedRandom:
                let wordgenerator = Wordgenerator(
                    iterator: WeightedRandomIterator(tokenizer))
                try writeWords(
                    from: wordgenerator,
                    to: output,
                    withEncoding: outputEncoding)
            case .descendingProbability:
                let wordgenerator = Wordgenerator(
                    iterator: NaiveDescendingProbabilityIterator(
                        tokenizer,
                        maxWordLength: wordLength!))
                try writeWords(
                    from: wordgenerator,
                    to: output,
                    withEncoding: outputEncoding)
            }
        }
        
        private func writeWords
        <Wordgenerator: Sequence>(
            from wordgenerator: Wordgenerator, to path: String,
            withEncoding encoding: String.Encoding)
        throws where Wordgenerator.Element: StringProtocol {
            let outputData = wordgenerator
                .lazy
                .prefix(count)
                .joined(separator: seperator ?? "\n")
                .data(using: encoding)
            do {
                try outputData?.write(to: URL(fileURLWithPath: path))
            } catch {
                throw CodingError.unableToWrite(forEncoding: encoding)
            }
        }
    }
}
