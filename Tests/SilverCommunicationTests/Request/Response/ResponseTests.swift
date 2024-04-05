//
//  ResponseTests.swift
//
//
//  Created by Kjeld Groot on 05/04/2024.
//

import XCTest

@testable import SilverCommunication

final class ResponseTests: XCTestCase {
    private var sut: Response<Data?>!
    
    func testInitializeWithHTTPResponse() throws {
        let url = try XCTUnwrap(URL(string: "https://github.com"))
        let headers = [HTTPHeader.contentType: ContentType.json.headerValue, .language: "en-US"]
        
        for statusCode in [200, 204, 400] {
            let httpResponse = try XCTUnwrap(HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: headers
            ))
            let content = Data("Test".utf8)
            sut = Response(httpResponse: httpResponse, content: content)
            
            XCTAssertEqual(sut.statusCode, httpResponse.statusCode)
            XCTAssertEqual(sut.headers, headers)
            XCTAssertEqual(sut.content, content)
        }
    }
}
