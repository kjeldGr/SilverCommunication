//
//  ValueError.swift
//  SilverCommunication
//
//  Created by Kjeld Groot on 17/03/2025.
//

import Foundation

public protocol ValueErrorContext {
    associatedtype Root
    associatedtype Value
    
    var keyPath: KeyPath<Root, Value> { get }
    var underlyingError: Error? { get }
}

public enum ValueError: Error {
    public struct Context<Root, Value>: ValueErrorContext {
        public let keyPath: KeyPath<Root, Value>
        public var underlyingError: Error?
    }
    
    case invalidValue(Any, context: any ValueErrorContext)
    case missingValue(context: any ValueErrorContext)
}
