//
//  ContentType.swift
//
//
//  Created by Kjeld Groot on 03/04/2024.
//

public enum ContentType: Equatable {
    case custom(headerValue: String)
    case imageJPEG
    case imagePNG
    case json
    case multipart(boundary: String)
    case octetStream
    case text
    
    public var headerValue: String {
        switch self {
        case let .custom(headerValue):
            return headerValue
        case .imageJPEG:
            return "image/jpeg"
        case .imagePNG:
            return "image/png"
        case .json:
            return "application/json"
        case let .multipart(boundary):
            return "multipart/form-data; boundary=\(boundary)"
        case .octetStream:
            return "application/octet-stream"
        case .text:
            return "text/plain"
        }
    }
}
