//
//  MultipartFile.swift
//
//
//  Created by Kjeld Groot on 30/11/2023.
//

import Foundation

public struct MultipartFile: MultipartItemType {
    
    public enum ContentType: Equatable {
        case custom(header: String, fileExtension: String)
        case jpeg(compressToBytes: Int? = nil)
        case json
        case png
        
        var header: String {
            switch self {
            case let .custom(header, _):
                return header
            case .jpeg:
                return "image/jpeg"
            case .json:
                return "application/json"
            case .png:
                return "image/png"
            }
        }
        var fileExtension: String {
            switch self {
            case let .custom(_, fileExtension):
                return fileExtension
            case .jpeg:
                return "jpg"
            case .json:
                return "json"
            case .png:
                return "png"
            }
        }
    }
    
    // MARK: - Public properties
    
    public let data: Data
    public let name: String
    public let contentType: ContentType
    
    // MARK: - MultipartItemType
    
    public var bodyData: Data {
        var bodyData = Data()
        bodyData.append(Data("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(name).\(contentType.fileExtension)\"\r\n".utf8))
        bodyData.append(Data("Content-Type: \(contentType.header)\r\n\r\n".utf8))
        bodyData.append(data)
        bodyData.append(Data("\r\n".utf8))
        return bodyData
    }
    
    // MARK: - Initializers
    
    public init(data: Data, name: String, contentType: ContentType) {
        self.data = data
        self.name = name
        self.contentType = contentType
    }
}
