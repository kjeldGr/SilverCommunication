//
//  DictionaryParser.swift
//  
//
//  Created by Kjeld Groot on 21/03/2023.
//

import Foundation

public struct DictionaryParser<Key: Hashable, Value>: Parser {
    
    // MARK: - Public properties
    
    public let keyPath: String?
    
    // MARK: - Initializers
    
    public init(keyPath: String? = nil) {
        self.keyPath = keyPath
    }
    
    // MARK: - Parser
    
    public func parse(data: Data) throws -> [Key: Value] {
        guard let rootDictionary = try JSONSerialization.jsonObject(with: data) as? [AnyHashable: Any] else {
            throw ParserError.invalidData(data)
        }
        var result: Any?
        if let keyPath {
            result = NSDictionary(dictionary: rootDictionary).value(forKeyPath: keyPath)
        } else {
            result = rootDictionary
        }
        switch result {
        case let dictionary as ResultType:
            return dictionary
        case .some:
            throw ParserError.invalidData(data)
        case .none:
            throw ParserError.missingData
        }
    }
}
