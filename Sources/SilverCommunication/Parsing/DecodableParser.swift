//
//  DecodableParser.swift
//  
//
//  Created by Kjeld Groot on 21/03/2023.
//

import Foundation

public struct DecodableParser<ResultType: Decodable>: Parser {
    
    // MARK: - Public properties
    
    public let keyPath: String?
    public let jsonDecoder: JSONDecoder
    
    // MARK: - Initializers
    
    public init(keyPath: String? = nil, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.keyPath = keyPath
        self.jsonDecoder = jsonDecoder
    }
    
    // MARK: - Parser
    
    public func parse(data: Data) throws -> ResultType {
        var data = data
        if let keyPath = keyPath {
            let dictionary = try NSDictionary(dictionary: DictionaryParser().parse(data: data))
            switch dictionary.value(forKeyPath: keyPath) {
            case let value as ResultType:
                return value
            case let value as [AnyHashable: Any]:
                data = try JSONSerialization.data(withJSONObject: value)
            case let value as [Any]:
                data = try JSONSerialization.data(withJSONObject: value)
            case .some:
                throw ParserError.invalidData(data)
            case .none:
                throw ParserError.missingData
            }
        }
        return try jsonDecoder.decode(ResultType.self, from: data)
    }
}
