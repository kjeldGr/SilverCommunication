//
//  Response.swift
//
//
//  Created by Kjeld Groot on 31/03/2024.
//

public struct Response<ContentType> {
    public let statusCode: Int
    public let headers: [AnyHashable: Any]
    public let content: ContentType
    
    // MARK: - Initializers
    
    public init(statusCode: Int, headers: [AnyHashable : Any], content: ContentType) {
        self.statusCode = statusCode
        self.headers = headers
        self.content = content
    }
}
