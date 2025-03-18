//
//  DecodableParser.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 21/03/2023.
//

import Foundation

public struct DecodableParser<ContentType: Decodable>: Parser {
    
    // MARK: - Public properties
    
    public let keyPath: String?
    public let jsonDecoder: JSONDecoder
    
    // MARK: - Initializers
    
    public init(keyPath: String? = nil, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.keyPath = keyPath
        self.jsonDecoder = jsonDecoder
    }
    
    // MARK: - Parser
    
    public func parse(response: Response<Data>) throws -> Response<ContentType> {
        guard let keyPath else {
            return try response.map { try jsonDecoder.decode(ContentType.self, from: $0) }
        }
        
        return try DictionaryParser().parse(response: response).map { content in
            switch NSDictionary(dictionary: content).value(forKeyPath: keyPath) {
            case let value as ContentType:
                return value
            case let value as [AnyHashable: Any]:
                return try jsonDecoder.decode(ContentType.self, from: JSONSerialization.data(withJSONObject: value))
            case let value as [Any]:
                return try jsonDecoder.decode(ContentType.self, from: JSONSerialization.data(withJSONObject: value))
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
