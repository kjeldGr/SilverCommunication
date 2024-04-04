//
//  ArrayParserTests.swift
//  
//
//  Created by Kjeld Groot on 30/05/2023.
//

import XCTest

@testable import SilverCommunication

extension ArrayParser: TestableParser where ResultType: Equatable {
    typealias TestableResultType = ResultType
}

final class ArrayParserTests: ParserTestCase<ArrayParser<Int>> {
    
    // MARK: - XCTestCase
    
    override func setUp() {
        super.setUp()
        
        sut = ArrayParser()
        result = [1, 2, 3]
        invalidResult = ["test": "test"]
    }
    
    // MARK: - Tests
    
    override func testParseDataWithKeyPath() throws {
        sut = ArrayParser(keyPath: "keyPath")
        
        try super.testParseDataWithKeyPath()
    }
    
    override func testParseDataWithKeyPathWithInvalidData() throws {
        sut = ArrayParser(keyPath: "keyPath")
        
        try super.testParseDataWithKeyPathWithInvalidData()
    }
    
    override func testParseDataWithInvalidKeypath() throws {
        sut = ArrayParser(keyPath: "invalid")
        
        try super.testParseDataWithInvalidKeypath()
    }
}
