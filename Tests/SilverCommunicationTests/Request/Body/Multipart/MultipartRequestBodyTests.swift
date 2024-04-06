//
//  MultipartRequestBodyTests.swift
//  
//
//  Created by Kjeld Groot on 04/04/2024.
//

import XCTest

@testable import SilverCommunication

final class MultipartRequestBodyTests: XCTestCase {
    private var sut: MultipartRequestBody!
    
    func testData() {
        let boundary = "boundary"
        sut = MultipartRequestBody(
            boundary: "boundary",
            items: [
                MultipartItem(text: "text", name: "name")
            ]
        )
        XCTAssertEqual(
            sut.data,
            Data("--\(boundary)\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\ntext\r\n--\(boundary)--\r\n".utf8)
        )
    }
}
