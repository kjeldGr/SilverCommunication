//
//  Models.swift
//  
//
//  Created by Kjeld Groot on 30/05/2023.
//

import Foundation

struct CodableObject: Codable, Equatable {
    let id: String
    let title: String
}

struct CodableObjectStorage: Codable, Equatable {
    let object: CodableObject
    var creationDate: Date = Date()
}
