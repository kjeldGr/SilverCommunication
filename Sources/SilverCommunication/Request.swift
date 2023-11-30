//
//  Request.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 31/08/2019.
//

import Foundation

public struct Request {
    
    public typealias Header = String
    
    // MARK: - HTTPMethod
    
    public enum HTTPMethod: String {
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case connect = "CONNECT"
        case options = "OPTIONS"
        case trace = "TRACE"
        case patch = "PATCH"
    }
    
    // MARK: - Content
    
    public enum HTTPBody: Equatable {
        case data(Data)
        case dictionary([AnyHashable: AnyHashable])
        case encodable(Encodable, encoder: JSONEncoder = JSONEncoder())
        case multipart(MultipartRequestBody)
        
        public static func == (lhs: Request.HTTPBody, rhs: Request.HTTPBody) -> Bool {
            switch (lhs, rhs) {
            case let (.data(lhs), .data(rhs)):
                return lhs == rhs
            case let (.dictionary(lhs), .dictionary(rhs)):
                return lhs == rhs
            case let (.encodable(lhsEncodable, lhsEncoder), .encodable(rhsEncodable, rhsEncoder)):
                let lhsData = try? lhsEncoder.encode(lhsEncodable)
                let rhsData = try? rhsEncoder.encode(rhsEncodable)
                return lhsData == rhsData
            case let (.multipart(lhs), .multipart(rhs)):
                return lhs == rhs
            default:
                return false
            }
        }
    }
    
    // MARK: - Public properties
    
    public let httpMethod: HTTPMethod
    public let path: String
    public let parameters: [String: Any]?
    public let headers: [Header: String]?
    public let body: HTTPBody?
    
    // MARK: - Initializers
    
    public init(
        httpMethod: HTTPMethod = .get,
        path: String,
        parameters: [String: Any]? = nil,
        headers: [Header: String]? = nil,
        body: HTTPBody? = nil
    ) {
        self.httpMethod = httpMethod
        self.path = path
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }
    
}

public extension Request.Header {
    static let accept: String = "Accept"
    static let authorization: String = "Authorization"
    static let contentType: String = "Content-Type"
    static let userAgent: String = "User-Agent"
}
