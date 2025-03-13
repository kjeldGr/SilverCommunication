//
//  Constants.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 12/03/2025.
//

import Foundation
import SilverCommunication

extension URL {
    static let gitHub: URL = URL(string: "https://api.github.com")!
    static let httpBin: URL = URL(string: "https://httpbin.org")!
}

extension RequestManager {
    static let gitHub: RequestManager = RequestManager(baseURL: .gitHub)
    static let httpBin: RequestManager = RequestManager(baseURL: .httpBin)
}
