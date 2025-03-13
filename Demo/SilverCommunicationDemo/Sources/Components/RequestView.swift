//
//  RequestView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 12/03/2025.
//

import SwiftUI

struct RequestView: View {
    
    // MARK: - Internal properties
    
    let baseURL: URL
    @Binding var context: RequestContext
    let performRequestAction: () -> Void
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PropertyView(
                title: "Base URL",
                value: baseURL.absoluteString
            )
            RequestPropertiesView(
                context: $context
            )
            Button("Perform request", action: performRequestAction)
                .buttonStyle(.bordered)
        }
    }
}

// MARK: - Previews

#Preview("GET") {
    @Previewable @State var context: RequestContext = RequestContext(
        path: "preview",
        httpMethod: .get
    )
    
    RequestView(
        baseURL: .gitHub,
        context: $context
    ) {}
}

#Preview("POST") {
    @Previewable @State var context: RequestContext = RequestContext(
        path: "preview",
        httpMethod: .post
    )
    
    RequestView(
        baseURL: .gitHub,
        context: $context
    ) {}
}
