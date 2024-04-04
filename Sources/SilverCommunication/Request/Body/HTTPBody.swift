//
//  HTTPBody.swift
//
//
//  Created by Kjeld Groot on 04/04/2024.
//

import Foundation

public enum HTTPBody: Equatable {
    case binary(Binary)
    case multipart(MultipartRequestBody)
    
    public init(data: Data, contentType: ContentType = .octetStream()) {
        self = .binary(Binary(data: data, contentType: contentType))
    }
    
    public init(jsonObject: Any) throws {
        self = try .binary(Binary(jsonObject: jsonObject))
    }
    
    public init(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws {
        self = try .binary(Binary(encodable: encodable, encoder: encoder))
    }
    
    public var contentType: ContentType {
        switch self {
        case let .binary(binary):
            return binary.contentType
        case let .multipart(multipartRequestBody):
            return .multipart(boundary: multipartRequestBody.boundary)
        }
    }
    
    public var data: Data {
        switch self {
        case let .binary(binary):
            return binary.data
        case let .multipart(multipartRequestBody):
            return multipartRequestBody.data
        }
    }
}
