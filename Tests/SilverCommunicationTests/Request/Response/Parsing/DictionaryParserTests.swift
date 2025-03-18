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

extension DictionaryParser: TestableParser where ContentType: Equatable {
    typealias TestableContentType = ContentType
}

final class DictionaryParserTests: ParserTestCase<DictionaryParser<String, String>> {
    
    // MARK: - XCTestCase
    
    override func setUp() {
        super.setUp()
        
        sut = DictionaryParser()
        result = ["test": "test"]
        invalidResult = [1, 2, 3]
    }
    
    // MARK: - Tests
    
    override func testParseDataWithKeyPath() throws {
        sut = DictionaryParser(keyPath: "keyPath")
        
        try super.testParseDataWithKeyPath()
    }
    
    override func testParseDataWithKeyPathWithInvalidData() throws {
        sut = DictionaryParser(keyPath: "keyPath")
        
        try super.testParseDataWithKeyPathWithInvalidData()
    }
    
    override func testParseDataWithInvalidKeypath() throws {
        sut = DictionaryParser(keyPath: "invalid")
        
        try super.testParseDataWithInvalidKeypath()
    }
}
