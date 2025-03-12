//
//  TextResponseView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI

struct TextResponseView: View {
    
    // MARK: - Internal properties
    
    let data: Data
    
    // MARK: - Private properties
    
    @State private var format: TextResponseFormat = .raw
    
    // MARK: - View
    
    var body: some View {
        VStack {
            Picker("Response format", selection: $format) {
                ForEach(TextResponseFormat.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            .pickerStyle(.segmented)
            Text(Self.makeFormattedText(data: data, format: format))
        }
    }
    
    // MARK: - Private methods
    
    private static func makeFormattedText(
        data: Data,
        format: TextResponseFormat
    ) -> String {
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
}

// MARK: - TextResponseFormat

private enum TextResponseFormat: String, CaseIterable {
    case raw = "Raw"
    case json = "JSON"
}

// MARK: - Previews

#Preview {
    TextResponseView(
        data: Data("{\"key\": \"value\"}".utf8)
    )
}
