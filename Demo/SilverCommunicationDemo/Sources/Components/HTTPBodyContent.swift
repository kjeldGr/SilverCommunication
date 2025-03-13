//
//  HTTPBodyContent.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SilverCommunication
import SwiftUI

struct HTTPBodyContent: View {
    
    // MARK: - ContentType
    
    enum ContentType: String, CaseIterable {
        case jsonDictionary = "JSON Dictionary"
        case jsonList = "JSON List"
        case text = "Text"
    }
    
    // MARK: - Internal properties
    
    @Binding var httpBody: HTTPBody?
    
    // MARK: - Private properties
    
    @State private var contentType: ContentType = .text
    @State private var dictionaryItems: [DictionaryItem] = []
    @State private var list: [String] = []
    @State private var text: String = ""
    
    // MARK: - View
    
    var body: some View {
        Picker("Content Type", selection: $contentType) {
            ForEach(ContentType.allCases, id: \.self) {
                Text($0.rawValue).tag($0)
            }
        }
        .onChange(of: contentType) { _, _ in
            updateHTTPBody()
        }
        switch contentType {
        case .jsonDictionary:
            DictionaryItemArrayContent(items: $dictionaryItems)
                .onChange(of: dictionaryItems) { _, _ in
                    updateHTTPBody()
                }
        case .jsonList:
            StringArrayContent(items: $list)
                .onChange(of: list) { _, _ in
                    updateHTTPBody()
                }
        case .text:
            LabeledContent("Body") {
                TextField("Body", text: $text)
            }
            .onChange(of: text) { _, _ in
                updateHTTPBody()
            }
        }
    }
    
    // MARK: - Private methods
    
    private func updateHTTPBody() {
        switch contentType {
        case .jsonDictionary where dictionaryItems.isEmpty,
                .jsonList where list.isEmpty,
                .text where text.isEmpty:
            httpBody = nil
        case .jsonDictionary:
            httpBody = try? HTTPBody(jsonObject: dictionaryItems.dictionary)
        case .jsonList:
            httpBody = try? HTTPBody(jsonObject: list)
        case .text:
            httpBody = HTTPBody(
                data: Data(text.utf8),
                contentType: .text
            )
        }
    }
}

// MARK: - Previews

#Preview {
    @Previewable @State var httpBody: HTTPBody?
    
    List {
        HTTPBodyContent(httpBody: $httpBody)
    }
}
