//
//  URLRequest+Request.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 08/11/2019.
//

import Foundation

extension URLRequest {
    
    // MARK: - Error
    
    enum Error: Swift.Error {
        case invalidURL
    }
    
    // MARK: - Initializers
    
    init(baseURL: URL, request: Request) throws {
        let url = baseURL.appendingPathComponent(request.path)
        guard let urlString = url.absoluteString.removingPercentEncoding,
              let url = URL(string: urlString),
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw Error.invalidURL
        }
        var request = request
        if let contentType = request.body?.contentType {
            request.appendHeader(key: .contentType, value: contentType.headerValue, override: false)
        }
        
        let queryItems = request.parameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        if let componentsQueryItems = urlComponents.queryItems {
            urlComponents.queryItems = componentsQueryItems + (queryItems ?? [])
        } else {
            urlComponents.queryItems = queryItems
        }
        
        urlComponents.percentEncodedQueryItems = urlComponents.queryItems?.map { queryItem in
            guard let encodedValue = queryItem.value?.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                return queryItem
            }
            return URLQueryItem(name: queryItem.name, value: encodedValue)
        }
        
        guard let url = urlComponents.url else {
            throw Error.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body?.data
        self = urlRequest
    }
}
