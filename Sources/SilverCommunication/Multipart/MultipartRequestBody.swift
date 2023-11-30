//
//  MultipartRequestBody.swift
//
//
//  Created by Kjeld Groot on 30/11/2023.
//

import Foundation

public struct MultipartRequestBody: Equatable {
    
    // MARK: - Internal properties
    
    let boundary: String
    let items: [MultipartItem]
    var httpBody: Data {
        var httpBody = items.reduce(into: Data()) { partialResult, item in
            partialResult.append(Data("--\(boundary)\r\n".utf8))
            partialResult.append(item.bodyData)
        }
        httpBody.append(Data("--\(boundary)--".utf8))
        return httpBody
    }
    
    // MARK: - Initializers
    
    public init(boundary: String = UUID().uuidString, items: [MultipartItem]) {
        self.boundary = boundary
        self.items = items
    }
    
    public init(boundary: String = UUID().uuidString, itemTypes: [any MultipartItemType]) {
        self.boundary = boundary
        self.items = itemTypes.map { MultipartItem(item: $0) }
    }
}
