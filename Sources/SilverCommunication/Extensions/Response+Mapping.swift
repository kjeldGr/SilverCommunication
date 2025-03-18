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
