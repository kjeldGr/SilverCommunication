//
//  ParserTestCase.swift
//
//
//  Created by Kjeld Groot on 30/05/2023.
//

import XCTest

@testable import SilverCommunication

protocol TestableParser: Parser {
    associatedtype TestableContentType: Equatable
    
    func parse(response: Response<Data>) throws -> Response<TestableContentType>
}

class ParserTestCase<P: TestableParser>: XCTestCase {
    
    // MARK: - SUT
    
    var sut: P!
    
    // MARK: - Internal properties
    
    var result: P.TestableContentType!
    var invalidResult: Any!
    
    // MARK: - XCTestCase
    
    override func tearDown() {
        self.invalidResult = nil
        self.result = nil
        self.sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testParseData() throws {
        let data = try JSONSerialization.data(withJSONObject: result!)
        XCTAssertEqual(try sut.parse(response: Response(statusCode: 200, headers: [:], content: data)).content, result)
    }
    
    func testParseDataWithInvalidData() throws {
        let data = try JSONSerialization.data(withJSONObject: invalidResult!)
        try XCTAssertThrowsError(sut.parse(response: Response(statusCode: 200, headers: [:], content: data)).content) { error in
            switch error {
            case let ValueError.invalidValue(parserData, context as ValueError.Context<Response<Data>, Data>):
                XCTAssertEqual(data, parserData as? Data)
                XCTAssertEqual(context.keyPath, \.content)
                XCTAssertNil(context.underlyingError)
            default:
                XCTFail("Expected parse(data:) to fail with ValueError.invalidValue, failed with \(String(reflecting: error)) instead.")
            }
        }
    }
    
    func testParseDataWithKeyPath() throws {
        let data = try JSONSerialization.data(withJSONObject: ["keyPath": result])
        try XCTAssertEqual(sut.parse(response: Response(statusCode: 200, headers: [:], content: data)).content, result)
    }
    
    func testParseDataWithKeyPathWithInvalidData() throws {
        let data = try JSONSerialization.data(withJSONObject: ["keyPath": invalidResult])
        try XCTAssertThrowsError(sut.parse(response: Response(statusCode: 200, headers: [:], content: data))) { error in
            switch error {
            case let ValueError.invalidValue(parserData, context as ValueError.Context<Response<Data>, Data>):
                XCTAssertEqual(data, parserData as? Data)
                XCTAssertEqual(context.keyPath, \.content)
                XCTAssertNil(context.underlyingError)
            default:
                XCTFail("Expected parse(data:) to fail with ValueError.invalidValue, failed with \(String(reflecting: error)) instead.")
            }
        }
    }
    
    func testParseDataWithInvalidKeypath() throws {
        let data = try JSONSerialization.data(withJSONObject: ["keyPath": result])
        try XCTAssertThrowsError(sut.parse(response: Response(statusCode: 200, headers: [:], content: data))) { error in
            switch error {
            case let ValueError.missingValue(context as ValueError.Context<Response<Data>, Data>):
                XCTAssertEqual(context.keyPath, \.content)
                XCTAssertNil(context.underlyingError)
            default:
                XCTFail("Expected parse(data:) to fail with ValueError.invalidValue, failed with \(String(reflecting: error)) instead.")
            }
        }
    }
}
