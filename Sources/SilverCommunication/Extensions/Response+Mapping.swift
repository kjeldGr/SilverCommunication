//
//  Response+Mapping.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 07/04/2024.
//

public extension Response {
    @inlinable func map<T>(_ transform: (ContentType) throws -> T) rethrows -> Response<T> {
        try Response<T>(statusCode: statusCode, headers: headers, content: transform(content))
    }
}

public extension Response {
    func unwrap<T>() throws -> Response<T> where T? == ContentType {
        try map { content in
            guard let content else {
                throw ValueError.missingValue(context: ValueError.Context(keyPath: \Response<T>.content))
            }
            return content
        }
    }
}
