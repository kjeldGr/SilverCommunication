//
//  ArrayParser.swift
//  
//
//  Created by Kjeld Groot on 21/03/2023.
//

import Foundation

public struct ArrayParser<Element>: Parser {
    
    // MARK: - Public properties
    
    public let keyPath: String?
    
    // MARK: - Initializers
    
    public init(keyPath: String? = nil) {
        self.keyPath = keyPath
    }
    
    // MARK: - Parser
    
    public func parse(data: Data) throws -> [Element] {
        var result: Any?
        if let keyPath {
            result = try NSDictionary(
                dictionary: DictionaryParser().parse(data: data)
            ).value(forKeyPath: keyPath)
        } else {
            result = try JSONSerialization.jsonObject(with: data)
        }
        switch result {
        case let array as [Element]:
            return array
        case .some:
            throw ParserError.invalidData(data)
        case .none:
            throw ParserError.missingData
        }
    }
}
