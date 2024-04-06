//
//  RequestManager.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 31/08/2019.
//

import Foundation

/// Errors that will be thrown by `RequestManager`.
public enum RequestManagerError: Error {
    /// Error that indicates the response is invalid
    case invalidResponse
    /// Error that indicates the request response has no data
    case missingData
}

public final class RequestManager: ObservableObject {
    
    // MARK: - Public properties
    
    public let baseURL: URL
    public private(set) var defaultHeaders: [HTTPHeader: String]?
    
    // MARK: - Internal properties
    
    let urlSession: URLSession
    
    // MARK: - Initializers
    
    /// Initializer for testing purpose, enables the developer to mock the `URLSession`
    /// - Parameters:
    ///   - baseURL: The base url for the performed requests
    ///   - defaultHeaders: These headers will be added to all requests, performed by this `RequestManager`
    public convenience init(baseURL: URL, defaultHeaders: [HTTPHeader: String]? = nil) {
        self.init(baseURL: baseURL, urlSession: .shared, defaultHeaders: defaultHeaders)
    }
    
    /// Initializer for testing purpose, enables the developer to mock the `URLSession`
    /// - Parameters:
    ///   - baseURL: The base url for the performed requests
    ///   - urlSession: The url session used to create data tasks
    ///   - defaultHeaders: These headers will be added to all requests, performed by this `RequestManager`
    init(baseURL: URL, urlSession: URLSession, defaultHeaders: [HTTPHeader: String]?) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.defaultHeaders = defaultHeaders
    }
    
    // MARK: - RequestManager
    
    /// Append new headers to the default headers used by this `RequestManager`. New headers with keys that already exist will override the existing headers.
    /// - Parameter key: The key to add to the default headers.
    /// - Parameter value: The value to add to the default headers for the provided key
    /// - Parameter override: Boolean to determine if the new header should override existing default headers when the key already exists.
    public func appendDefaultHeader(key: HTTPHeader, value: String, override: Bool = true) {
        self.defaultHeaders = [key: value].merging(self.defaultHeaders ?? [:]) { current, new in
            override ? current : new
        }
    }
    
    /// Remove header from the default headers used by this `RequestManager`.
    /// - Parameter key: The key to remove from the default headers
    public func removeDefaultHeader(key: HTTPHeader) {
        self.defaultHeaders?.removeValue(forKey: key)
    }
    
    /// Perform a `Request` and execute the passed completion with the data received in the request response, parsed to the passed `Response` type
    /// - Parameters:
    ///   - request: The `Request` to perform
    ///   - validators: The `ResponseValidator`'s that will be used for response validation
    ///   - callbackQueue: The `DispatchQueue` on which the completion is called
    ///   - completion: The completion containing a `Result` type with a `Response` value on success or an `Error` on failure
    @discardableResult
    public func perform(
        request: Request,
        validators: [ResponseValidator] = [StatusCodeValidator()],
        callbackQueue: DispatchQueue = .main,
        completion: @escaping (Result<Response<Data?>, Error>) -> Void
    ) -> URLSessionTask? {
        var request = request
        if let defaultHeaders {
            defaultHeaders.forEach { key, value in
                request.appendHeader(key: key, value: value, override: false)
            }
        }
        let urlRequest: URLRequest
        do {
            urlRequest = try URLRequest(baseURL: baseURL, request: request)
        } catch {
            callbackQueue.async {
                completion(.failure(error))
            }
            return nil
        }
        
        // Execute URLRequest
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            callbackQueue.async {
                do {
                    if let error {
                        throw error
                    }
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw RequestManagerError.invalidResponse
                    }
                    let response = Response(httpResponse: httpResponse, content: data)
                    try validators.forEach { try $0.validate(response: response) }
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        return task
    }
    
    /// Perform a `Request` and execute the passed completion with the data received in the request response, parsed to the passed `Response` type
    /// - Parameters:
    ///   - request: The `Request` to perform
    ///   - validators: The `ResponseValidator`'s that will be used for response validation
    ///   - parser: The parser that will be used for the request
    ///   - callbackQueue: The `DispatchQueue` on which the completion is called
    ///   - completion: The completion containing a `Result` type with a `Response` value on success or an `Error` on failure
    @discardableResult
    public func perform<P: Parser>(
        request: Request,
        validators: [ResponseValidator] = [StatusCodeValidator()],
        parser: P,
        callbackQueue: DispatchQueue = .main,
        completion: @escaping (Result<Response<P.ResultType>, Error>) -> Void
    ) -> URLSessionTask? {
        perform(request: request, validators: validators, callbackQueue: callbackQueue) { result in
            do {
                switch result {
                case let .success(response):
                    completion(.success(try parser.parse(response: response.unwrap())))
                case let .failure(error):
                    throw error
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Perform a `Request`
    /// - Parameters:
    ///   - request: The `Request` to perform
    ///   - validators: The `ResponseValidator`'s that will be used for response validation
    /// - Returns: The request response
    @discardableResult
    public func perform(
        request: Request,
        validators: [ResponseValidator] = [StatusCodeValidator()]
    ) async throws -> Response<Data?> {
        try await withCheckedThrowingContinuation { continuation in
            perform(request: request, validators: validators) { result in
                continuation.resume(with: result)
            }
        }
    }
    
    /// Perform a `Request`
    /// - Parameters:
    ///   - request: The `Request` to perform
    ///   - validators: The `ResponseValidator`'s that will be used for response validation
    ///   - parser: The parser that will be used for the request
    /// - Returns: The data received in the request response, parsed to the passed `Response` type
    public func perform<P: Parser>(
        request: Request,
        validators: [ResponseValidator] = [StatusCodeValidator()],
        parser: P
    ) async throws -> Response<P.ResultType> {
        try await parser.parse(response: perform(request: request, validators: validators).unwrap())
    }
    
}

private extension Response where ContentType == Data? {
    func unwrap() throws -> Response<Data> {
        guard let content else { throw RequestManagerError.missingData }
        return Response<Data>(statusCode: statusCode, headers: headers, content: content)
    }
}
