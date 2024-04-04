//
//  MultipartItem.swift
//
//
//  Created by Kjeld Groot on 04/04/2024.
//

import Foundation

public struct MultipartItem: Equatable {
    public let content: Data
    public let name: String
    public let filename: String?
    public let contentType: ContentType?
    
    var data: Data {
        var data = Data("Content-Disposition: form-data; name=\"\(name)\"".utf8)
        if let filename {
            data.append(Data("; filename=\"\(filename)\"".utf8))
        }
        if let contentTypeData = contentType?.multipartData {
            data.appendNewLine()
            data.append(contentTypeData)
        }
        data.appendNewLine()
        data.appendNewLine()
        data.append(content)
        data.appendNewLine()
        
        return data
    }
}

extension MultipartItem {
    public init(text: String, name: String) {
        self.init(content: Data(text.utf8), name: name, filename: nil, contentType: nil)
    }
    
    public init(binary: Binary, name: String) {
        let filename = binary.contentType.fileExtension.flatMap { "\(name).\($0)" } ?? name
        self.init(content: binary.data, name: name, filename: filename, contentType: binary.contentType)
    }
    
    public init(binary: Binary, name: String, filename: String) {
        self.init(content: binary.data, name: name, filename: filename, contentType: binary.contentType)
    }
}

private extension ContentType {
    var multipartData: Data {
        return Data("Content-Type: \(headerValue)".utf8)
    }
    var fileExtension: String? {
        switch self {
        case .imageJPEG:
            return "jpg"
        case .imagePNG:
            return "png"
        case .json:
            return "json"
        case .text:
            return "txt"
        case .custom, .multipart, .octetStream:
            return nil
        }
    }
}

private extension Data {
    mutating func appendNewLine() {
        append(Data("\r\n".utf8))
    }
}
