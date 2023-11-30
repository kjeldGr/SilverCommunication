//
//  MultipartField.swift
//
//
//  Created by Kjeld Groot on 30/11/2023.
//

import Foundation

public struct MultipartField: MultipartItemType {
    
    // MARK: - Public properties
    
    public let data: Data
    public let type: String
    public let name: String
    
    // MARK: - MultipartItemType
    
    public var bodyData: Data {
        var bodyData = Data()
        bodyData.append(Data("Content-Type: \(type); charset=ISO-8859-1\r\n".utf8))
        bodyData.append(Data("Content-Transfer-Encoding: 8bit\r\n".utf8))
        bodyData.append(Data("Content-Disposition: form-data; name=\"\(name)\"\"\r\n\r\n".utf8))
        bodyData.append(data)
        bodyData.append(Data("\r\n".utf8))
        return bodyData
    }
    
    // MARK: - Initializers
    
    public init(value: String, name: String) {
        self.data = Data(value.utf8)
        self.type = "text/plain"
        self.name = name
    }
}
