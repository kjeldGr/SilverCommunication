//
//  URLSessionMocks.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 08/11/2019.
//

import Foundation

// MARK: - URLSessionMock

final class URLSessionMock: URLSession, @unchecked Sendable {
    
    // MARK: - Private properties
    
    private let mockingMethod: MockingMethod
    
    // MARK: - Initializers
    
    init(mockingMethod: MockingMethod) {
        self.mockingMethod = mockingMethod
        
        super.init()
    }
    
    // MARK: - URLSession
    
    override func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        URLSessionDataTaskMock(
            request: request,
            mockingMethod: mockingMethod
        ) { data, response, error in
            completionHandler(data, response, error)
        }
    }
    
    override func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: URLRequest(url: url), completionHandler: completionHandler)
    }
}

// MARK: - URLSessionDataTaskMock

private final class URLSessionDataTaskMock: URLSessionDataTask, @unchecked Sendable {
    
    // MARK: - URLSessionDataTask
    
    override var originalRequest: URLRequest? {
        request
    }
    
    override var currentRequest: URLRequest? {
        originalRequest
    }
    
    // MARK: - Private properties
    
    private let request: URLRequest
    private let mockingMethod: MockingMethod
    private let completionHandler: (Data?, URLResponse?, Error?) -> Void
    
    // MARK: - Initializers
    
    init(
        request: URLRequest,
        mockingMethod: MockingMethod,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) {
        self.request = request
        self.mockingMethod = mockingMethod
        self.completionHandler = completionHandler
        
        super.init()
    }
    
    // MARK: - URLSessionDataTask
    
    override func resume() {
        do {
            let (data, response) = try parse(mockingMethod: mockingMethod)
            completionHandler(data, response, nil)
        } catch {
            completionHandler(nil, makeResponse(statusCode: 500), error)
        }
    }
    
    private func parse(mockingMethod: MockingMethod) throws -> (data: Data?, response: HTTPURLResponse?) {
        switch mockingMethod {
        case let .response(response, data):
            return (data: data, response: response)
        case let .data(data, statusCode):
            return try parse(mockingMethod: .response(makeResponse(statusCode: statusCode), data: data))
        case let .encodable(value, encoder, statusCode):
            return try parse(mockingMethod: .data(encoder.encode(value), statusCode: statusCode))
        case let .file(filename, fileExtension, bundle, statusCode):
            let data = try bundle.dataFromFile(
                withName: filename,
                withExtension: fileExtension
            )
            return try parse(mockingMethod: .data(data, statusCode: statusCode))
        case let .bundle(bundleName, bundle):
            let path = request.httpMethod.flatMap { httpMethod in
                request.url.flatMap { url in
                    URL(string: httpMethod)?.appendingPathComponent(url.path)
                }?.path
            }
            let data = try path.flatMap {
                try bundle.dataFromBundle(
                    withName: bundleName,
                    forPath: $0,
                    withExtension: "json"
                )
            }
            return try parse(mockingMethod: .data(data, statusCode: 200))
        case let .error(error):
            throw error
        }
    }
    
    private func makeResponse(statusCode: Int) -> HTTPURLResponse? {
        request.url.flatMap {
            HTTPURLResponse(
                url: $0,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )
        }
    }
}
