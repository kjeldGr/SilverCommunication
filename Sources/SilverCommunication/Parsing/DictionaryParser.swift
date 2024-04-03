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
    
    public func parse(response: Response<Data>) throws -> Response<[Key: Value]> {
        guard let rootDictionary = try JSONSerialization.jsonObject(with: response.content) as? [AnyHashable: Any] else {
            throw ParserError.invalidData(response.content)
        }
        var content: Any?
        if let keyPath {
            content = NSDictionary(dictionary: rootDictionary).value(forKeyPath: keyPath)
        } else {
            content = rootDictionary
        }
        switch content {
        case let content as ResultType:
            return Response(statusCode: response.statusCode, headers: response.headers, content: content)
        case .some:
            throw ParserError.invalidData(response.content)
        case .none:
            throw ParserError.missingData
        }
    }
}
