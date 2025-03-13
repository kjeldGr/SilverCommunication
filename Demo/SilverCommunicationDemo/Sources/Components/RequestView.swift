//
//  RequestView.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 12/03/2025.
//

import SwiftUI

struct RequestView<Footer: View>: View {
    
    // MARK: - Internal properties
    
    let baseURL: URL
    @Binding var requestContext: RequestContext
    let performRequestAction: () -> Void
    @ViewBuilder let footer: () -> Footer
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PropertyView(
                title: "Base URL",
                value: baseURL.absoluteString
            )
            RequestPropertiesView(
                request: $requestContext
            )
            Button("Perform request", action: performRequestAction)
                .buttonStyle(.bordered)
            footer()
        }
    }
}

// MARK: - Previews

#Preview("GET") {
    @Previewable @State var requestContext: RequestContext = RequestContext(
        path: "preview",
        httpMethod: .get
    )
    
    RequestView(
        baseURL: Constants.gitHubBaseURL,
        requestContext: $requestContext
    ) {} footer: {
        EmptyView()
    }
}

#Preview("POST") {
    @Previewable @State var requestContext: RequestContext = RequestContext(
        path: "preview",
        httpMethod: .post
    )
    
    RequestView(
        baseURL: Constants.gitHubBaseURL,
        requestContext: $requestContext
    ) {} footer: {
        EmptyView()
    }
}
