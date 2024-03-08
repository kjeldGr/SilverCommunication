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
        
        var additionalHeaders: [Header: String]? {
            switch self {
            case .data:
                return nil
            case .dictionary, .encodable:
                return [.contentType: "application/json"]
            case let .multipart(multipartRequestBody):
                return [.contentType: "multipart/form-data; boundary=\(multipartRequestBody.boundary)"]
            }
        }
        
        func httpBody() throws -> Data {
            switch self {
            case let .data(data):
                return data
            case let .dictionary(dictionary):
                return try JSONSerialization.data(withJSONObject: dictionary)
            case let .encodable(encodable, encoder):
                return try encoder.encode(encodable)
            case let .multipart(multipartRequestBody):
                return multipartRequestBody.httpBody
            }
        }
        
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
    public private(set) var parameters: [String: Any]?
    public private(set) var headers: [Header: String]?
    public let body: HTTPBody?
    
    // MARK: - Internal properties
    
    private(set) var bodyParser: any Parser<Data>
    
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
        self.bodyParser = FixedDataParser()
    }
    
    public init<P: Parser<Data>>(
        httpMethod: HTTPMethod = .get,
        path: String,
        parameters: [String: Any]? = nil,
        headers: [Header: String]? = nil,
        body: HTTPBody? = nil,
        bodyParser: P
    ) {
        self.httpMethod = httpMethod
        self.path = path
        self.parameters = parameters
        self.headers = headers
        self.body = body
        self.bodyParser = bodyParser
    }
    
    // MARK: - Internal methods
    
    mutating func append(parameters: [String: Any]?) {
        guard let parameters else { return }
        self.parameters = parameters.merging(self.parameters ?? [:]) { _, new in new }
    }
    
    mutating func append(headers: [Header: String]?) {
        guard let headers else { return }
        self.headers = headers.merging(self.headers ?? [:]) { _, new in new }
    }
    
    mutating func set<P: Parser<Data>>(bodyParser: P) {
        self.bodyParser = bodyParser
    }
}

public extension Request.Header {
    static let accept: String = "Accept"
    static let authorization: String = "Authorization"
    static let contentType: String = "Content-Type"
    static let language: String = "Accept-Language"
    static let userAgent: String = "User-Agent"
}

private struct FixedDataParser: Parser {
    func parse(data: Data) throws -> Data { data }
}
