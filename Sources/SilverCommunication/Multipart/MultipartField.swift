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
    public let name: String
    
    // MARK: - MultipartItemType
    
    public var bodyData: Data {
        var bodyData = Data()
        bodyData.append(Data("Content-Disposition: form-data; name=\"\(name)\"\"\r\n\r\n".utf8))
        bodyData.append(data)
        bodyData.append(Data("\r\n".utf8))
        return bodyData
    }
    
    // MARK: - Initializers
    
    public init(value: String, name: String) {
        self.data = Data(value.utf8)
        self.name = name
    }
}
