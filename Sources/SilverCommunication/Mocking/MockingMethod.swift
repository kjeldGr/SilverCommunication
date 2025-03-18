//
//  MockingMethod.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 07/06/2022.
//

import Foundation

public enum MockingMethod {
    case response(URLResponse?, data: Data? = nil)
    case data(Data?, statusCode: Int = 200)
    case encodable(Encodable, encoder: JSONEncoder = JSONEncoder(), statusCode: Int = 200)
    case file(name: String, fileExtension: String = "json", bundle: Bundle, statusCode: Int = 200)
    case bundle(name: String, bundle: Bundle)
    case error(Error)
}
