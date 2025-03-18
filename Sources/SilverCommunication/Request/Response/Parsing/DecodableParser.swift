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
    
    public func parse(response: Response<Data>) throws -> Response<ResultType> {
        let content: ResultType
        if let keyPath = keyPath {
            let dictionary = try NSDictionary(dictionary: DictionaryParser().parse(response: response).content)
            switch dictionary.value(forKeyPath: keyPath) {
            case let value as ResultType:
                content = value
            case let value as [AnyHashable: Any]:
                content = try jsonDecoder.decode(ResultType.self, from: JSONSerialization.data(withJSONObject: value))
            case let value as [Any]:
                content = try jsonDecoder.decode(ResultType.self, from: JSONSerialization.data(withJSONObject: value))
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
        } else {
            content = try jsonDecoder.decode(ResultType.self, from: response.content)
        }
        return Response(statusCode: response.statusCode, headers: response.headers, content: content)
    }
}
