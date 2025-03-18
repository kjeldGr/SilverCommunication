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
    static let mock: URL = URL(string: "https://thiscouldbeanyurl.com")!
}

extension RequestManager {
    static let gitHub: RequestManager = RequestManager(baseURL: .gitHub)
    static let httpBin: RequestManager = RequestManager(baseURL: .httpBin)
    static let mock: RequestManager = RequestManager(
        baseURL: .mock,
        mockingMethod: .bundle(name: "Mock", bundle: .main)
    )
}
