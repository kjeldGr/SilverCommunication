//
//  RequestManager.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 31/08/2019.
//

import Foundation

public final class RequestManager {
    
    // MARK: - Public properties
    
    public let baseURL: URL
    public private(set) var defaultHeaders: [HTTPHeader: String]?
    
    // MARK: - Internal properties
    
    let urlSession: URLSession
    
    // MARK: - Initializers
    
    /// Public initializer for the `RequestManager`
    /// - Parameters:
    ///   - baseURL: The base URL for the performed requests
    ///   - defaultHeaders: These headers will be added to all requests, performed by this `RequestManager`
    public convenience init(baseURL: URL, defaultHeaders: [HTTPHeader: String]? = nil) {
        self.init(baseURL: baseURL, urlSession: .shared, defaultHeaders: defaultHeaders)
    }
    
    /// Public initializer for the `RequestManager` with added convenience for unwrapping URL strings
    /// - Parameters:
    ///   - baseURL: The base URL in String format for the performed requests
    ///   - defaultHeaders: These headers will be added to all requests, performed by this `RequestManager`
    public convenience init(baseURL: String, defaultHeaders: [HTTPHeader: String]? = nil) throws {
        guard let baseURL = URL(string: baseURL) else {
            throw ValueError.invalidValue(
                baseURL,
                context: ValueError.Context(keyPath: \RequestManager.baseURL)
            )
        }
        self.init(baseURL: baseURL, defaultHeaders: defaultHeaders)
    }
    
    /// Initializer for testing purpose, enables the developer to mock the `URLSession`
    /// - Parameters:
    ///   - baseURL: The base URL for the performed requests
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
                        throw ValueError.invalidValue(
                            response,
                            context: ValueError.Context(keyPath: \URLSessionDataTask.response)
                        )
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
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
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
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    public func perform<P: Parser>(
        request: Request,
        validators: [ResponseValidator] = [StatusCodeValidator()],
        parser: P
    ) async throws -> Response<P.ResultType> {
        try await withCheckedThrowingContinuation { continuation in
            perform(request: request, validators: validators, parser: parser) { result in
                continuation.resume(with: result)
            }
        }
    }
}

// MARK: - RequestManager+ObservableObject

#if canImport(Combine)
import Combine

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension RequestManager: ObservableObject {}
#endif

// MARK: - Response+Unwrap

private extension Response where ContentType == Data? {
    func unwrap() throws -> Response<Data> {
        try map { content in
            guard let content else {
                throw ValueError.invalidValue(
                    nil,
                    context: ValueError.Context(keyPath: \Response<Data>.content)
                )
            }
            return content
        }
    }
}
