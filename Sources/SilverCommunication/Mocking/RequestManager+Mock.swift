//
//  RequestManager+Mock.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 07/06/2022.
//

import Foundation

public extension RequestManager {
    convenience init(
        baseURL: URL,
        mockingMethod: MockingMethod,
        defaultHeaders: [HTTPHeader: String]? = nil
    ) {
        let urlSession = URLSessionMock(mockingMethod: mockingMethod)
        self.init(baseURL: baseURL, urlSession: urlSession, defaultHeaders: defaultHeaders)
    }
    
    convenience init(
        baseURL: String,
        mockingMethod: MockingMethod,
        defaultHeaders: [HTTPHeader: String]? = nil
    ) throws {
        guard let baseURL = URL(string: baseURL) else {
            throw RequestManagerError.invalidBaseURL
        }
        self.init(baseURL: baseURL, mockingMethod: mockingMethod, defaultHeaders: defaultHeaders)
    }
}
