//
//  DictionaryParser.swift
//  SilverCommunication
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
        try response.map { content in
            guard let rootDictionary = try JSONSerialization.jsonObject(with: content) as? [AnyHashable: Any] else {
                throw ValueError.invalidValue(
                    content,
                    context: ValueError.Context(keyPath: \Response<Data>.content)
                )
            }
            var content: Any?
            if let keyPath {
                content = NSDictionary(dictionary: rootDictionary).value(forKeyPath: keyPath)
            } else {
                content = rootDictionary
            }
            switch content {
            case let content as ContentType:
                return content
            case .some:
                throw ValueError.invalidValue(
                    response.content,
                    context: ValueError.Context(keyPath: \Response<Data>.content)
                )
            case .none:
                throw ValueError.missingValue(
                    context: ValueError.Context(keyPath: \Response<Data>.content)
                )
            }
        }
    }
}
