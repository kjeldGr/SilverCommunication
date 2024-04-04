//
//  HTTPBodyTests.swift
//
//
//  Created by Kjeld Groot on 04/04/2024.
//

import XCTest

@testable import SilverCommunication

final class HTTPBodyTests: XCTestCase {
    private var sut: HTTPBody!
    
    func testConvenienceInitializers() throws {
        let data = Data("test".utf8)
        sut = HTTPBody(data: data)
        XCTAssertEqual(sut.contentType, .octetStream())
        XCTAssertEqual(sut.data, data)
        
        sut = HTTPBody(data: data, contentType: .json)
        XCTAssertEqual(sut.contentType, .json)
        XCTAssertEqual(sut.data, data)
        
        let jsonObject = ["Test": "Test"]
        sut = try HTTPBody(jsonObject: jsonObject)
        XCTAssertEqual(sut.contentType, .json)
        try XCTAssertEqual(sut.data, JSONSerialization.data(withJSONObject: jsonObject))
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let encodable = CodableObject(id: "id", title: "title")
        sut = try HTTPBody(encodable: encodable, encoder: encoder)
        XCTAssertEqual(sut.contentType, .json)
        try XCTAssertEqual(sut.data, encoder.encode(encodable))
    }
    
    func testProperties() throws {
        var binary = try Binary(jsonObject: ["test": "test"])
        sut = .binary(binary)
        XCTAssertEqual(sut.contentType, .json)
        XCTAssertEqual(sut.data, binary.data)
        
        binary = try Binary(encodable: CodableObject(id: "id", title: "title"))
        sut = .binary(binary)
        XCTAssertEqual(sut.contentType, .json)
        XCTAssertEqual(sut.data, binary.data)
        
        binary = Binary(data: Data(), contentType: .text)
        sut = .binary(binary)
        XCTAssertEqual(sut.contentType, binary.contentType)
        XCTAssertEqual(sut.data, binary.data)
        
        binary = Binary(data: Data(), contentType: .imagePNG)
        sut = .binary(binary)
        XCTAssertEqual(sut.contentType, binary.contentType)
        XCTAssertEqual(sut.data, binary.data)
        
        let multipartRequestResponse = MultipartRequestBody(items: [])
        sut = .multipart(multipartRequestResponse)
        XCTAssertEqual(sut.contentType, .multipart(boundary: multipartRequestResponse.boundary))
        XCTAssertEqual(sut.data, multipartRequestResponse.data)
    }
}
