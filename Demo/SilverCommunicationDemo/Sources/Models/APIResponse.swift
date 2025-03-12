//
//  APIResponse.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 12/03/2025.
//

import Foundation

struct APIResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case arguments = "args"
        case data
        case headers
        case json
        case origin
        case url
    }
    
    let arguments: [String: String]
    let data: String?
    let headers: [String: String]
    let json: Any?
    let origin: String
    let url: URL
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.arguments = try container.decode([String: String].self, forKey: .arguments)
        self.data = try container.decodeIfPresent(String.self, forKey: .data)
        self.headers = try container.decode([String: String].self, forKey: .headers)
        let jsonData = try container.decodeIfPresent(Data.self, forKey: .json)
        self.json = try jsonData.flatMap { try JSONSerialization.jsonObject(with: $0) }
        self.origin = try container.decode(String.self, forKey: .origin)
        self.url = try container.decode(URL.self, forKey: .url)
    }
}
