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
        let headers: [Request.Header: String]?
        let httpBody: Data?
        switch request.body {
        case let .data(data):
            headers = request.headers
            httpBody = data
        case let .dictionary(dictionary):
            headers = [
                .contentType: "application/json"
            ].merging(request.headers ?? [:]) { _, new in new }
            httpBody = try JSONSerialization.data(withJSONObject: dictionary)
        case let .encodable(encodable, encoder):
            headers = [
                .contentType: "application/json"
            ].merging(request.headers ?? [:]) { _, new in new }
            httpBody = try encoder.encode(encodable)
        case .none:
            headers = request.headers
            httpBody = nil
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
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpBody = httpBody
        self = urlRequest
    }
}
