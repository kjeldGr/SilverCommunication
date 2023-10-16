//
//  File 2.swift
//  
//
//  Created by KPGroot on 30/05/2023.
//

import XCTest

@testable import SilverCommunication

protocol TestableParser: Parser {
    associatedtype TestableResultType: Equatable
    
    func parse(data: Data) throws -> TestableResultType
}

class ParserTestCase<P: TestableParser>: XCTestCase {
    
    // MARK: - SUT
    
    var sut: P!
    
    // MARK: - Internal properties
    
    var result: P.TestableResultType!
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
        XCTAssertEqual(try sut.parse(data: data), result)
    }
    
    func testParseDataWithInvalidData() throws {
        let data = try JSONSerialization.data(withJSONObject: invalidResult!)
        try XCTAssertThrowsError(sut.parse(data: data)) { error in
            switch error {
            case let ParserError.invalidData(parserData):
                XCTAssertEqual(data, parserData)
            default:
                XCTFail("Expected parse(data:) to fail with ParserError.invalidData, failed with \(String(reflecting: error)) instead.")
            }
        }
    }
    
    func testParseDataWithKeyPath() throws {
        let data = try JSONSerialization.data(withJSONObject: ["keyPath": result])
        try XCTAssertEqual(sut.parse(data: data), result)
    }
    
    func testParseDataWithKeyPathWithInvalidData() throws {
        let data = try JSONSerialization.data(withJSONObject: ["keyPath": invalidResult])
        try XCTAssertThrowsError(sut.parse(data: data)) { error in
            switch error {
            case let ParserError.invalidData(parserData):
                XCTAssertEqual(data, parserData)
            default:
                XCTFail("Expected parse(data:) to fail with ParserError.invalidData, failed with \(String(reflecting: error)) instead.")
            }
        }
    }
    
    func testParseDataWithInvalidKeypath() throws {
        let data = try JSONSerialization.data(withJSONObject: ["keyPath": result])
        try XCTAssertThrowsError(sut.parse(data: data)) { error in
            switch error {
            case ParserError.missingData:
                break
            default:
                XCTFail("Expected parse(data:) to fail with ParserError.noData, failed with \(String(reflecting: error)) instead.")
            }
        }
    }
}
