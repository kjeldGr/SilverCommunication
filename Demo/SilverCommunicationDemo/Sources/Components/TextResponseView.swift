//
//  TextResponseView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI

enum TextResponseFormat: String {
    case raw
    case json
}

struct TextResponseView: View {
    
    // MARK: - Internal properties
    
    let data: Data
    private(set) var format: TextResponseFormat
    
    // MARK: - Private properties
    
    var formattedText: String {
        do {
            switch format {
            case .raw:
                return String(decoding: data, as: UTF8.self)
            case .json:
                let object = try JSONSerialization.jsonObject(
                    with: data
                )
                let data = try JSONSerialization.data(
                    withJSONObject: object,
                    options: .prettyPrinted
                )
                return String(decoding: data, as: UTF8.self)
            }
        } catch {
            return "Unable to format response to text"
        }
    }
    
    // MARK: - Initializers
    
    init(data: Data, format: TextResponseFormat) {
        self.data = data
        self.format = format
    }
    
    init(text: String) {
        self.data = Data(text.utf8)
        self.format = .raw
    }
    
    // MARK: - View
    
    var body: some View {
        Text(formattedText)
    }
}

// MARK: - Previews

#Preview("Default") {
    TextResponseView(text: "Response")
}

#Preview("JSON") {
    TextResponseView(
        data: Data("{\"key\": \"value\"}".utf8),
        format: .json
    )
}
