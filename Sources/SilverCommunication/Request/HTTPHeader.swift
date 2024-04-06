//
//  HTTPHeader.swift
//  
//
//  Created by Kjeld Groot on 05/04/2024.
//

public typealias HTTPHeader = String

public extension HTTPHeader {
    static let accept: String = "Accept"
    static let authorization: String = "Authorization"
    static let contentType: String = "Content-Type"
    static let language: String = "Accept-Language"
    static let userAgent: String = "User-Agent"
}

