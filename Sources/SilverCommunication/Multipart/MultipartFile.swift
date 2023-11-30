//
//  MultipartFile.swift
//
//
//  Created by Kjeld Groot on 30/11/2023.
//

import Foundation

public struct MultipartFile: MultipartItemType {
    
    // MARK: - Public properties
    
    public let data: Data
    public let type: String
    public let name: String
    public let fileExtension: String
    
    // MARK: - MultipartItemType
    
    public var bodyData: Data {
        var bodyData = Data()
        bodyData.append(Data("Content-Type: \(type)\r\n".utf8))
        bodyData.append(Data("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(name).\(fileExtension)\"\r\n\r\n".utf8))
        bodyData.append(data)
        bodyData.append(Data("\r\n".utf8))
        return bodyData
    }
    
    // MARK: - Initializers
    
    public init(data: Data, type: String, name: String, fileExtension: String) {
        self.data = data
        self.type = type
        self.name = name
        self.fileExtension = fileExtension
    }
}
