//
//  MultipartFile+JSON.swift
//
//
//  Created by Kjeld Groot on 30/11/2023.
//

import Foundation

public extension MultipartFile {
    init(json: String, name: String = UUID().uuidString) {
        self.init(jsonData: Data(json.utf8), name: name)
    }
    
    init(encodable: Encodable, encoder: JSONEncoder = JSONEncoder(), name: String = UUID().uuidString) throws {
        try self.init(jsonData: encoder.encode(encodable), name: name)
    }
    
    private init(jsonData: Data, name: String) {
        self.init(data: jsonData, type: "application/json", name: name, fileExtension: "json")
    }
}
