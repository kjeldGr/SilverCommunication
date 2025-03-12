//
//  DataParser.swift
//
//
//  Created by Kjeld Groot on 12/03/2025.
//

import Foundation

/// `Parser` that will just forward the `Response` with the `Data` content as is. This can be used to make sure data is not `null` in the `Response`
public struct DataParser: Parser {
    
    // MARK: - Parser
    
    public func parse(response: Response<Data>) throws -> Response<Data> {
        return response
    }
}
