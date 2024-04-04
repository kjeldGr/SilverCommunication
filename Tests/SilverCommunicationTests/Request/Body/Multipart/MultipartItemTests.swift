//
//  MultipartItemTests.swift
//  
//
//  Created by Kjeld Groot on 04/04/2024.
//

import XCTest

@testable import SilverCommunication

final class MultipartItemTests: XCTestCase {
    private var sut: MultipartItem!
    
    func testInitializers() {
        sut = MultipartItem(text: "text", name: "name")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: Data("text".utf8), name: "name", filename: nil, contentType: nil).data
        )
        
        var binary = Binary(data: Data("text".utf8), contentType: .custom(rawValue: "Custom"))
        sut = MultipartItem(binary: binary, name: "name")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: binary.data, name: "name", filename: "name", contentType: binary.contentType).data
        )
        
        binary = Binary(data: Data("text".utf8), contentType: .custom(rawValue: "Custom", fileExtension: "pdf"))
        sut = MultipartItem(binary: binary, name: "name")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: binary.data, name: "name", filename: "name.pdf", contentType: binary.contentType).data
        )
        
        binary = Binary(data: Data("text".utf8), contentType: .imageJPEG)
        sut = MultipartItem(binary: binary, name: "name")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: binary.data, name: "name", filename: "name.jpg", contentType: binary.contentType).data
        )
        
        binary = Binary(data: Data("text".utf8), contentType: .imagePNG)
        sut = MultipartItem(binary: binary, name: "name")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: binary.data, name: "name", filename: "name.png", contentType: binary.contentType).data
        )
        
        binary = Binary(data: Data("text".utf8), contentType: .json)
        sut = MultipartItem(binary: binary, name: "name")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: binary.data, name: "name", filename: "name.json", contentType: binary.contentType).data
        )
        
        binary = Binary(data: Data("text".utf8), contentType: .multipart(boundary: "boundary"))
        sut = MultipartItem(binary: binary, name: "name")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: binary.data, name: "name", filename: "name", contentType: binary.contentType).data
        )
        
        binary = Binary(data: Data("text".utf8), contentType: .octetStream())
        sut = MultipartItem(binary: binary, name: "name")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: binary.data, name: "name", filename: "name", contentType: binary.contentType).data
        )
        
        binary = Binary(data: Data("text".utf8), contentType: .octetStream(fileExtension: "csv"))
        sut = MultipartItem(binary: binary, name: "name")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: binary.data, name: "name", filename: "name.csv", contentType: binary.contentType).data
        )
        
        binary = Binary(data: Data("text".utf8), contentType: .text)
        sut = MultipartItem(binary: binary, name: "name")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: binary.data, name: "name", filename: "name.txt", contentType: binary.contentType).data
        )
        
        sut = MultipartItem(binary: binary, name: "name", filename: "filename.any")
        XCTAssertEqual(
            sut.data,
            MultipartItem(content: binary.data, name: "name", filename: "filename.any", contentType: binary.contentType).data
        )
    }
    
    func testData() {
        let name = "name"
        let text = "text"
        sut = MultipartItem(text: text, name: name)
        
        XCTAssertEqual(
            sut.data,
            Data("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n\(text)\r\n".utf8)
        )
        
        var binary = Binary(data: Data(text.utf8), contentType: .json)
        sut = MultipartItem(binary: binary, name: name)
        XCTAssertEqual(
            sut.data,
            Data("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(name).json\"\r\nContent-Type: application/json\r\n\r\n\(text)\r\n".utf8)
        )
        
        binary = Binary(data: Data(text.utf8), contentType: .imageJPEG)
        sut = MultipartItem(binary: binary, name: name)
        XCTAssertEqual(
            sut.data,
            Data("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(name).jpg\"\r\nContent-Type: image/jpeg\r\n\r\n\(text)\r\n".utf8)
        )
        
        binary = Binary(data: Data(text.utf8), contentType: .imageJPEG)
        let filename = "custom.any"
        sut = MultipartItem(binary: binary, name: name, filename: filename)
        XCTAssertEqual(
            sut.data,
            Data("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\nContent-Type: image/jpeg\r\n\r\n\(text)\r\n".utf8)
        )
    }
}
