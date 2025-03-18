//
//  Parser.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 21/03/2023.
//

import Foundation

public protocol Parser<ContentType> {
    associatedtype ContentType
    
    func parse(response: Response<Data>) throws -> Response<ContentType>
}
