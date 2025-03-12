//
//  HTTPBodyView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SilverCommunication
import SwiftUI

struct HTTPBodyView: View {
    
    // MARK: - ContentType
    
    enum ContentType: String, CaseIterable {
        case json = "JSON"
        case text = "Text"
    }
    
    // MARK: - Internal properties
    
    @Binding var httpBody: HTTPBody?
    
    // MARK: - Private properties
    
    @State private var contentType: ContentType = .text
    @State private var text: String = ""
    
    // MARK: - View
    
    var body: some View {
        PropertyView(
            title: "HTTP Body"
        ) {
            PropertyView(axis: .horizontal, title: "Content Type") {
                Picker("Content Type", selection: $contentType) {
                    ForEach(ContentType.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
            }
            TextField("HTTP Body", text: $text, axis: .vertical)
        }
        .onChange(of: text) { _, _ in
            updateHTTPBody()
        }
        .onChange(of: contentType) { _, _ in
            updateHTTPBody()
        }
    }
    
    // MARK: - Private methods
    
    private func updateHTTPBody() {
        switch contentType {
        case _ where text.isEmpty:
            httpBody = nil
        case .json:
            do {
                let jsonObject = try JSONSerialization.jsonObject(
                    with: Data(text.utf8)
                )
                httpBody = try HTTPBody(jsonObject: jsonObject)
            } catch {
                httpBody = HTTPBody(
                    data: Data("\(text) (JSON is invalid)".utf8),
                    contentType: .text
                )
            }
        case .text:
            httpBody = HTTPBody(
                data: Data(text.utf8),
                contentType: .text
            )
        }
    }
}

// TODO: Fix previews
//#Preview {
//    HTTPBodyView()
//}
