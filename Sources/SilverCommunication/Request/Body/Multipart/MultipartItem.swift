//
//  MultipartItem.swift
//
//
//  Created by Kjeld Groot on 04/04/2024.
//

import Foundation

public struct MultipartItem: Equatable {
    let data: Data
}

extension MultipartItem {
    public init(text: String, name: String) {
        self.init(
            data: Self.generateData(content: Data(text.utf8), name: name, contentType: nil, filename: nil)
        )
    }
    
    public init(binary: Binary, name: String) {
        let filename = binary.contentType.fileExtension.flatMap { "\(name).\($0)" } ?? name
        self.init(
            data: Self.generateData(content: binary.data, name: name, contentType: binary.contentType, filename: filename)
        )
    }
    
    public init(binary: Binary, name: String, filename: String) {
        self.init(
            data: Self.generateData(content: binary.data, name: name, contentType: binary.contentType, filename: filename)
        )
    }
    
    // MARK: - Factory methods
    
    static func generateData(content: Data, name: String, contentType: ContentType?, filename: String?) -> Data {
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

private extension ContentType {
    var multipartData: Data {
        return Data("Content-Type: \(rawValue)".utf8)
    }
    var fileExtension: String? {
        switch self {
        case let .custom(_, fileExtension?):
            return fileExtension
        case .imageJPEG:
            return "jpg"
        case .imagePNG:
            return "png"
        case .json:
            return "json"
        case let .octetStream(fileExtension?):
            return fileExtension
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
