//
//  ContentTypeTests.swift
//  
//
//  Created by Kjeld Groot on 04/04/2024.
//

import XCTest

@testable import SilverCommunication

final class ContentTypeTests: XCTestCase {
    private var sut: ContentType!
    
    func testHeaderValue() {
        let customHeaderValue = "test"
        sut = .custom(headerValue: customHeaderValue)
        XCTAssertEqual(sut.headerValue, customHeaderValue)
        
        sut = .imageJPEG
        XCTAssertEqual(sut.headerValue, "image/jpeg")
        
        sut = .imagePNG
        XCTAssertEqual(sut.headerValue, "image/png")
        
        sut = .json
        XCTAssertEqual(sut.headerValue, "application/json")
        
        let boundary = "boundary"
        sut = .multipart(boundary: boundary)
        XCTAssertEqual(sut.headerValue, "multipart/form-data; boundary=\(boundary)")
        
        sut = .octetStream
        XCTAssertEqual(sut.headerValue, "application/octet-stream")
        
        sut = .text
        XCTAssertEqual(sut.headerValue, "text/plain")
    }
}
