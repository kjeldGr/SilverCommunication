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

public final class RequestManager {
    
    // MARK: - Public properties
    
    public let baseURL: URL
    
    // MARK: - Internal properties
    
    let urlSession: URLSession
    
    // MARK: - Initializers
    
    /// Initializer for testing purpose, enables the developer to mock the `URLSession`
    /// - Parameters:
    ///   - baseURL: The base url for the performed requests
    public convenience init(baseURL: URL) {
        self.init(baseURL: baseURL, urlSession: .shared)
    }
    
    /// Initializer for testing purpose, enables the developer to mock the `URLSession`
    /// - Parameters:
    ///   - baseURL: The base url for the performed requests
    ///   - urlSession: The url session used to create data tasks
    init(baseURL: URL, urlSession: URLSession) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    // MARK: - RequestManager
    
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
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask? {
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
                    guard let response = response as? HTTPURLResponse else {
                        throw RequestManagerError.invalidResponse
                    }
                    try validators.forEach { try $0.validate(response: response) }
                    guard let data else {
                        throw RequestManagerError.missingData
                    }
                    completion(.success(data))
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
        completion: @escaping (Result<P.ResultType, Error>) -> Void
    ) -> URLSessionTask? {
        perform(request: request, validators: validators, callbackQueue: callbackQueue) { result in
            do {
                switch result {
                case let .success(data):
                    completion(.success(try parser.parse(data: data)))
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
    /// - Returns: The data received in the request response
    @discardableResult
    public func perform(
        request: Request,
        validators: [ResponseValidator] = [StatusCodeValidator()]
    ) async throws -> Data {
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
    ) async throws -> P.ResultType {
        try await parser.parse(data: perform(request: request, validators: validators))
    }
    
}
