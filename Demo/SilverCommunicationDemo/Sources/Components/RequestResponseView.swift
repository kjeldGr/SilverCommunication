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
    
    @Binding var response: Response<ContentType>?
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
    
    // TODO: Move to parsing response view
    @ViewBuilder
    private func listItem(for item: Any) -> some View {
        if let item = item as? [String: AnyHashable] {
            AnyView(ForEach(Array(item.keys), id: \.self) {
                PropertyView(
                    axis: .horizontal,
                    title: $0,
                    value: item[$0].flatMap { "\($0)" }
                )
            })
        } else if let item = item as? [AnyHashable] {
            AnyView(ForEach(item, id: \.self) {
                listItem(for: $0)
            })
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var response: Response<Any>? = nil
    
    RequestResponseView(response: $response) { _ in EmptyView() }
}
