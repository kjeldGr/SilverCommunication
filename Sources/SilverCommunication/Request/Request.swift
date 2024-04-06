//
//  Request.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 31/08/2019.
//

import Foundation

public struct Request {
    
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
    
    // MARK: - Public properties
    
    public let httpMethod: HTTPMethod
    public let path: String
    public private(set) var parameters: [String: Any]?
    public private(set) var headers: [HTTPHeader: String]?
    public let body: HTTPBody?
    
    // MARK: - Initializers
    
    public init(
        httpMethod: HTTPMethod = .get,
        path: String,
        parameters: [String: Any]? = nil,
        headers: [HTTPHeader: String]? = nil,
        body: HTTPBody? = nil
    ) {
        self.httpMethod = httpMethod
        self.path = path
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }
    
    // MARK: - Public methods
    
    public mutating func appendParameter(key: String, value: Any, override: Bool = true) {
        self.parameters = [key: value].merging(self.parameters ?? [:]) { current, new in
            override ? current : new
        }
    }
    
    public mutating func appendHeader(key: HTTPHeader, value: String, override: Bool = true) {
        self.headers = [key: value].merging(self.headers ?? [:]) { current, new in
            override ? current : new
        }
    }
}
