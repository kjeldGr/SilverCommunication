//
//  Binary+JSON.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 30/11/2023.
//

import Foundation

public extension Binary {
    init(jsonObject: Any) throws {
        try self.init(data: JSONSerialization.data(withJSONObject: jsonObject), contentType: .json)
    }
    
    init(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws {
        try self.init(data: encoder.encode(encodable), contentType: .json)
    }
}
