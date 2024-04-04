//
//  MultipartFile.swift
//
//
//  Created by Kjeld Groot on 30/11/2023.
//

import Foundation

public struct Binary: Equatable {
    
    // MARK: - Public properties
    
    public let data: Data
    public let contentType: ContentType
    
    // MARK: - Initializers
    
    public init(data: Data, contentType: ContentType) {
        self.data = data
        self.contentType = contentType
    }
}
