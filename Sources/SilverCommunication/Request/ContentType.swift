//
//  ContentType.swift
//
//
//  Created by Kjeld Groot on 03/04/2024.
//

public enum ContentType: Equatable {
    case custom(rawValue: String, fileExtension: String? = nil)
    case imageJPEG
    case imagePNG
    case json
    case multipart(boundary: String)
    case octetStream(fileExtension: String? = nil)
    case text
    
    public var rawValue: String {
        switch self {
        case let .custom(rawValue, _):
            return rawValue
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
