//
//  ArrayParser.swift
//  SilverCommunication
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
    
    public func parse(response: Response<Data>) throws -> Response<[Element]> {
        try response.map { content in
            var content: Any?
            if let keyPath {
                let dictionary = try NSDictionary(dictionary: DictionaryParser().parse(response: response).content)
                content = dictionary.value(forKeyPath: keyPath)
            } else {
                content = try JSONSerialization.jsonObject(with: response.content)
            }
            switch content {
            case let content as [Element]:
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
