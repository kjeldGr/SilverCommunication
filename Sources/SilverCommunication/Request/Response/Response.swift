//
//  Response.swift
//
//
//  Created by Kjeld Groot on 31/03/2024.
//

import Foundation

public struct Response<ContentType> {
    public let statusCode: Int
    public let headers: [HTTPHeader: String]
    public let content: ContentType
    
    // MARK: - Initializers
    
    public init(statusCode: Int, headers: [HTTPHeader: String], content: ContentType) {
        self.statusCode = statusCode
        self.headers = headers
        self.content = content
    }
    
    init(httpResponse: HTTPURLResponse, content: Data?) where ContentType == Data? {
        self.init(statusCode: httpResponse.statusCode, headers: httpResponse.headers, content: content)
    }
}

// MARK: - Mapping

private extension HTTPURLResponse {
    var headers: [HTTPHeader: String] {
        allHeaderFields.reduce(into: [HTTPHeader: String]()) { partialResult, item in
            let key = item.key.description
            if #available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
                if let value = value(forHTTPHeaderField: key) {
                    partialResult[key] = value
                }
            } else {
                switch item.value {
                case let value as String:
                    partialResult[key] = value
                case let value as LosslessStringConvertible:
                    partialResult[key] = String(value)
                case let value as NSNumber:
                    partialResult[key] = value.stringValue
                default:
                    break
                }
            }
        }
    }
}
