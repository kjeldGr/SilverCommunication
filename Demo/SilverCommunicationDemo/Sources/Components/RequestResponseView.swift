//
//  RequestResponseView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SilverCommunication
import SwiftUI

struct RequestResponseView<Footer: View>: View {
    
    // MARK: - Internal properties
    
    let statusCode: Int
    let headers: [String: String]
    @ViewBuilder var footer: () -> Footer
    
    // MARK: - View
    
    var body: some View {
        Section("Response") {
            LabeledContent(
                "Status",
                value: "\(statusCode)"
            )
        }
        if !headers.isEmpty {
            Section("Headers") {
                DictionaryItemArrayContent(
                    items: headers.items
                )
            }
        }
        footer()
    }
}

// MARK: - Previews

#Preview {
    List {
        RequestResponseView(
            statusCode: 200,
            headers: ["Key": "Value"]
        ) {
            EmptyView()
        }
    }
}
