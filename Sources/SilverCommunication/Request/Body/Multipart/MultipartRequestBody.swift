//
//  MultipartRequestBody.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 30/11/2023.
//

import Foundation

public struct MultipartRequestBody: Equatable {
    
    // MARK: - Public properties
    
    public let boundary: String
    public let items: [MultipartItem]
    
    // MARK: - Internal properties
    
    var data: Data {
        var httpBody = items.reduce(into: Data()) { partialResult, item in
            partialResult.append(Data("--\(boundary)\r\n".utf8))
            partialResult.append(item.data)
        }
        httpBody.append(Data("--\(boundary)--\r\n".utf8))
        return httpBody
    }
    
    // MARK: - Initializers
    
    public init(boundary: String = UUID().uuidString, items: [MultipartItem]) {
        self.boundary = boundary
        self.items = items
    }
}
