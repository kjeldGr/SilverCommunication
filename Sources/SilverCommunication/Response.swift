//
//  Response.swift
//
//
//  Created by Kjeld Groot on 31/03/2024.
//

import Foundation

public struct Response<ContentType> {
    let statusCode: Int
    let headers: [AnyHashable: Any]
    let content: ContentType
}
