//
//  StatusCodeValidatorTests.swift
//  
//
//  Created by Kjeld Groot on 31/05/2023.
//

import XCTest

@testable import SilverCommunication

final class StatusCodeValidatorTests: XCTestCase {
    
    // MARK: - Private properties
    
    private var sut: StatusCodeValidator!
    
    // MARK: - Tests
    
    func testStatusCodeValidatorWithValidStatusCodesRange() throws {
        sut = StatusCodeValidator(validStatusCodes: 200..<300)
        var statusCode = 200
        try sut.validate(response: makeResponse(statusCode: statusCode))
        
        statusCode = 199
        try XCTAssertThrowsError(sut.validate(response: makeResponse(statusCode: statusCode))) { error in
            switch error {
            case let ValueError.invalidValue(invalidStatusCode, context as ValueError.Context<Response<Data?>, Int>):
                XCTAssertEqual(statusCode, invalidStatusCode as? Int)
                XCTAssertEqual(context.keyPath, \.statusCode)
                XCTAssertNil(context.underlyingError)
            default:
                XCTFail("Expected validate(response:) to fail with ValueError.invalidValue, failed with \(String(reflecting: error)) instead.")
            }
        }
        
        statusCode = 300
        try XCTAssertThrowsError(sut.validate(response: makeResponse(statusCode: statusCode))) { error in
            switch error {
            case let ValueError.invalidValue(invalidStatusCode, context as ValueError.Context<Response<Data?>, Int>):
                XCTAssertEqual(statusCode, invalidStatusCode as? Int)
                XCTAssertEqual(context.keyPath, \.statusCode)
                XCTAssertNil(context.underlyingError)
            default:
                XCTFail("Expected validate(response:) to fail with ValueError.invalidValue, failed with \(String(reflecting: error)) instead.")
            }
        }
    }
    
    func testStatusCodeValidatorWithValidStatusCodesSet() throws {
        sut = StatusCodeValidator(validStatusCodes: [200, 201, 203, 204])
        var statusCode = 200
        try sut.validate(response: makeResponse(statusCode: statusCode))
        
        statusCode = 199
        try XCTAssertThrowsError(sut.validate(response: makeResponse(statusCode: statusCode))) { error in
            switch error {
            case let ValueError.invalidValue(invalidStatusCode, context as ValueError.Context<Response<Data?>, Int>):
                XCTAssertEqual(statusCode, invalidStatusCode as? Int)
                XCTAssertEqual(context.keyPath, \.statusCode)
                XCTAssertNil(context.underlyingError)
            default:
                XCTFail("Expected validate(response:) to fail with ValueError.invalidValue, failed with \(String(reflecting: error)) instead.")
            }
        }
        
        statusCode = 300
        try XCTAssertThrowsError(sut.validate(response: makeResponse(statusCode: statusCode))) { error in
            switch error {
            case let ValueError.invalidValue(invalidStatusCode, context as ValueError.Context<Response<Data?>, Int>):
                XCTAssertEqual(statusCode, invalidStatusCode as? Int)
                XCTAssertEqual(context.keyPath, \.statusCode)
                XCTAssertNil(context.underlyingError)
            default:
                XCTFail("Expected validate(response:) to fail with ValueError.invalidValue, failed with \(String(reflecting: error)) instead.")
            }
        }
    }
    
    private func makeResponse(statusCode: Int) -> Response<Data?> {
        Response(statusCode: statusCode, headers: [:], content: nil)
    }
}

