//
//  MultipartFile+JSON.swift
//
//
//  Created by Kjeld Groot on 30/11/2023.
//

import Foundation

public extension MultipartFile {
    init(json: String, name: String = UUID().uuidString) {
        self.init(data: Data(json.utf8), contentType: .json, name: name)
    }
    
    init(encodable: Encodable, encoder: JSONEncoder = JSONEncoder(), name: String = UUID().uuidString) throws {
        try self.init(data: encoder.encode(encodable), contentType: .json, name: name)
    }
}
