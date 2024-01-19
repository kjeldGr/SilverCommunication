//
//  Int+Bytes.swift
//
//
//  Created by Kjeld Groot on 19/01/2024.
//

public extension Int {
    static func bytes(_ bytes: Int) -> Int {
        bytes
    }
    
    static func kiloBytes(_ kiloBytes: Int) -> Int {
        kiloBytes * bytes(1_024)
    }
    
    static func megaBytes(_ megaBytes: Int) -> Int {
        megaBytes * kiloBytes(1_024)
    }
    
    static func gigaBytes(_ gigaBytes: Int) -> Int {
        gigaBytes * megaBytes(1_024)
    }
}
