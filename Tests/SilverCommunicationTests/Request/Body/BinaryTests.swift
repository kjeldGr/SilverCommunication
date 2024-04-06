//
//  BinaryTests.swift
//  
//
//  Created by Kjeld Groot on 04/04/2024.
//

import XCTest

@testable import SilverCommunication

final class BinaryTests: XCTestCase {
    private var sut: Binary!
    
    func testBinaryFromJSONObject() throws {
        let dictionary = ["test": "test"]
        let binary = try Binary(jsonObject: dictionary)
        
        try XCTAssertEqual(binary.data, JSONSerialization.data(withJSONObject: dictionary))
        XCTAssertEqual(binary.contentType, .json)
    }
    
    func testBinaryFromEncodable() throws {
        let encodable = CodableObject(id: "id", title: "title")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let binary = try Binary(encodable: encodable, encoder: encoder)
        
        try XCTAssertEqual(binary.data, encoder.encode(encodable))
        XCTAssertEqual(binary.contentType, .json)
    }
}
