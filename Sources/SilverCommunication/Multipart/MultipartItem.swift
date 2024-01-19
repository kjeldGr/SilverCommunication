//
//  MultipartItem.swift
//
//
//  Created by Kjeld Groot on 30/11/2023.
//

import Foundation

public protocol MultipartItemType: Equatable {
    var bodyData: Data { get }
}

public struct MultipartItem: Equatable {
    
    // MARK: - Internal properties
    
    let bodyData: Data
    
    // MARK: - Initializers
    
    public init(item: any MultipartItemType) {
        self.bodyData = item.bodyData
    }
}
