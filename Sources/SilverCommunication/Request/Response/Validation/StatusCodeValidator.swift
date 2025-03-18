//
//  StatusCodeValidator.swift
//  
//
//  Created by Kjeld Groot on 21/03/2023.
//

import Foundation

public struct StatusCodeValidator: ResponseValidator {
    public let validStatusCodes: Set<Int>
    
    public init(validStatusCodes: Range<Int>) {
        self.init(validStatusCodes: Set(validStatusCodes))
    }
    
    public init(validStatusCodes: Set<Int> = StatusCodeValidator.successCodes) {
        self.validStatusCodes = validStatusCodes
    }
    
    // MARK: - ResponseValidator
    
    public func validate(response: Response<Data?>) throws {
        if !validStatusCodes.contains(response.statusCode) {
            throw ValueError.invalidValue(
                response.statusCode,
                context: ValueError.Context(keyPath: \Response<Data?>.statusCode)
            )
        }
    }
}

public extension StatusCodeValidator {
    static let successCodes = Set(200..<300)
}
