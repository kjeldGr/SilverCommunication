//
//  ResponseValidator.swift
//  
//
//  Created by Kjeld Groot on 20/03/2023.
//

import Foundation

public protocol ResponseValidator {
    func validate(response: HTTPURLResponse) throws
}
