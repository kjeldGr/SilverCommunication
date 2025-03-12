//
//  RequestResponseView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SilverCommunication
import SwiftUI

struct RequestResponseView<ContentType, Footer: View>: View {
    
    // MARK: - Internal properties
    
    let response: Response<ContentType>?
    @ViewBuilder var footer: (ContentType) -> Footer
    
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
                if let content = response?.content {
                    footer(content)
                } else {
                    Text("N/A")
                        .font(.body)
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    RequestResponseView(
        response: Optional<Response<Any>>(nil)
    ) { _ in
        EmptyView()
    }
}
