//
//  RequestResponseView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI
import SilverCommunication

struct RequestResponseView: View {
    
    // MARK: - Internal properties
    
    @Binding var response: Response<Data?>?
    
    // MARK: - Private properties
    
    @State private var responseFormat: TextResponseFormat = .raw
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PropertyView(
                title: "Response status",
                value: response.flatMap {
                    "\($0.statusCode)"
                } ?? "N/A"
            )
            PropertyView(
                title: "Response headers",
                value: response.flatMap {
                    $0.headers.map {
                        "\($0.key): \($0.value)"
                    }.joined(separator: "\n")
                } ?? "N/A"
            )
            PropertyView(
                title: "Response"
            ) {
                VStack {
                    Picker("Response format", selection: $responseFormat) {
                        Text("Raw").tag(TextResponseFormat.raw)
                        Text("JSON").tag(TextResponseFormat.json)
                    }
                    .pickerStyle(.segmented)
                    if let content = response?.content {
                        TextResponseView(
                            data: content,
                            format: responseFormat
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var response: Response<Data?>? = nil
    
    RequestResponseView(response: $response)
}
