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
    
    func testRawValue() {
        let customRawValue = "test"
        sut = .custom(rawValue: customRawValue, fileExtension: "txt")
        XCTAssertEqual(sut.rawValue, customRawValue)
        
        sut = .imageJPEG
        XCTAssertEqual(sut.rawValue, "image/jpeg")
        
        sut = .imagePNG
        XCTAssertEqual(sut.rawValue, "image/png")
        
        sut = .json
        XCTAssertEqual(sut.rawValue, "application/json")
        
        let boundary = "boundary"
        sut = .multipart(boundary: boundary)
        XCTAssertEqual(sut.rawValue, "multipart/form-data; boundary=\(boundary)")
        
        sut = .octetStream(fileExtension: "txt")
        XCTAssertEqual(sut.rawValue, "application/octet-stream")
        
        sut = .text
        XCTAssertEqual(sut.rawValue, "text/plain")
    }
}
