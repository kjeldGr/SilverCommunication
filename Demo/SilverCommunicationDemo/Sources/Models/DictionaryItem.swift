//
//  DictionaryItem.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 13/03/2025.
//

struct DictionaryItem: Equatable {
    var key: String
    var value: String
}

extension Array where Element == (DictionaryItem) {
    var dictionary: [String: String] {
        reduce(into: [String: String]()) { partialResult, item in
            guard !item.key.isEmpty, !item.value.isEmpty else {
                return
            }
            partialResult[item.key] = item.value
        }
    }
}

extension Dictionary where Key == String, Value == String {
    var items: [DictionaryItem] {
        map { key, value in
            DictionaryItem(key: key, value: value)
        }
    }
}
