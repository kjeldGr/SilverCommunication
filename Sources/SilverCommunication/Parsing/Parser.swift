//
//  Parser.swift
//  
//
//  Created by Kjeld Groot on 21/03/2023.
//

import Foundation

public enum ParserError: Error {
    case missingData
    case invalidData(Data)
}

public protocol Parser<ResultType> {
    associatedtype ResultType
    
    func parse(response: Response<Data>) throws -> Response<ResultType>
}
