//
//  DictionaryParserTests.swift
//
//
//  Created by Kjeld Groot on 30/05/2023.
//

import XCTest

@testable import SilverCommunication

import XCTest

@testable import SilverCommunication

extension DecodableParser: TestableParser where ContentType: Equatable {
    typealias TestableContentType = ContentType
}

final class DecodableParserTests: ParserTestCase<DecodableParser<[String: String]>> {
    
    // MARK: - XCTestCase
    
    override func setUp() {
        super.setUp()
        
        sut = DecodableParser()
        result = ["id": "1", "title": "test"]
        invalidResult = [1, 2, 3]
    }
    
    // MARK: - ParserTestCase
    
    override func testParseDataWithKeyPath() throws {
        sut = DecodableParser(keyPath: "keyPath")
        
        try super.testParseDataWithKeyPath()
        
        let sut = DecodableParser<CodableObject>(keyPath: "keyPath")
        let data = try JSONSerialization.data(withJSONObject: ["keyPath": result])
        try XCTAssertEqual(
            sut.parse(response: Response(statusCode: 200, headers: [:], content: data)).content,
            JSONDecoder().decode(
                CodableObject.self,
                from: JSONSerialization.data(withJSONObject: result!)
            )
        )
    }
    
    override func testParseDataWithInvalidData() throws {
        let data = try JSONSerialization.data(withJSONObject: invalidResult!)
        try XCTAssertThrowsError(sut.parse(response: Response(statusCode: 200, headers: [:], content: data))) { error in
            switch error {
            case DecodingError.typeMismatch:
                break
            default:
                XCTFail("Expected parse(data:) to fail with DecodingError.typeMismatch, failed with \(String(reflecting: error)) instead.")
            }
        }
    }
    
    override func testParseDataWithKeyPathWithInvalidData() throws {
        sut = DecodableParser(keyPath: "keyPath")
        let data = try JSONSerialization.data(withJSONObject: ["keyPath": invalidResult!])
        try XCTAssertThrowsError(sut.parse(response: Response(statusCode: 200, headers: [:], content: data))) { error in
            switch error {
            case DecodingError.typeMismatch:
                break
            default:
                XCTFail("Expected parse(data:) to fail with DecodingError.typeMismatch, failed with \(String(reflecting: error)) instead.")
            }
        }
        
        invalidResult = 1
        try super.testParseDataWithKeyPathWithInvalidData()
    }
    
    override func testParseDataWithInvalidKeypath() throws {
        sut = DecodableParser(keyPath: "invalid")
        
        try super.testParseDataWithInvalidKeypath()
    }
    
    // MARK: - Tests
    
    func testParseDataWithJSONDecoder() throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let sut = DecodableParser<CodableObjectStorage>(jsonDecoder: decoder)
        let result = CodableObjectStorage(
            object: CodableObject(id: "1", title: "test")
        )
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        let data = try encoder.encode(result)
        try XCTAssertEqual(sut.parse(response: Response(statusCode: 200, headers: [:], content: data)).content.object, result.object)
        try XCTAssertEqual(
            sut.parse(response: Response(statusCode: 200, headers: [:], content: data)).content.creationDate.timeIntervalSince1970,
            result.creationDate.timeIntervalSince1970,
            accuracy: 0.001
        )
    }
}
