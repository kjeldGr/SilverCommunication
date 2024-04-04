//
//  StatusCodeValidator.swift
//  
//
//  Created by Kjeld Groot on 21/03/2023.
//

import Foundation

public enum StatusCodeValidatorError: Error {
    case invalidStatusCode(Int)
}

public struct StatusCodeValidator: ResponseValidator {
    public let validStatusCodes: Set<Int>
    
    public init(validStatusCodes: Range<Int>) {
        self.init(validStatusCodes: Set(validStatusCodes))
    }
    
    public init(validStatusCodes: Set<Int> = StatusCodeValidator.successCodes) {
        self.validStatusCodes = validStatusCodes
    }
    
    // MARK: - ResponseValidator
    
    public func validate(response: HTTPURLResponse) throws {
        if !validStatusCodes.contains(response.statusCode) {
            throw StatusCodeValidatorError.invalidStatusCode(response.statusCode)
        }
    }
}

public extension StatusCodeValidator {
    static let successCodes = Set(200..<300)
}
