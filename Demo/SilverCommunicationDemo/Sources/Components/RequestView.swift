//
//  RequestView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 12/03/2025.
//

import SilverCommunication
import SwiftUI

struct RequestView: View {
    
    // MARK: - Internal properties
    
    let baseURL: URL
    @Binding var context: RequestContext
    let performRequestAction: () -> Void
    
    // MARK: - View
    
    var body: some View {
        Section("Request") {
            LabeledContent("Base URL", value: baseURL.absoluteString)
            LabeledContent("Path", value: context.path)
        }
        Section("Query parameters") {
            DictionaryItemArrayContent(
                items: $context.queryParameters
            )
        }
        Section("Headers") {
            DictionaryItemArrayContent(
                items: $context.headers
            )
        }
        if context.httpMethod.isHTTPBodyFieldVisible {
            Section("HTTP Body") {
                HTTPBodyView(
                    httpBody: $context.httpBody
                )
            }
        }
        Button("Perform request", action: performRequestAction)
    }
}

// MARK: - HTTPMethod+HTTPBody

private extension Request.HTTPMethod {
    var isHTTPBodyFieldVisible: Bool {
        switch self {
        case .get:
            return false
        default:
            return true
        }
    }
}

// MARK: - Previews

#Preview("GET") {
    @Previewable @State var context: RequestContext = RequestContext(
        path: "preview",
        httpMethod: .get
    )
    
    List {
        RequestView(
            baseURL: .gitHub,
            context: $context
        ) {}
    }
}

#Preview("POST") {
    @Previewable @State var context: RequestContext = RequestContext(
        path: "preview",
        httpMethod: .post
    )
    
    List {
        RequestView(
            baseURL: .gitHub,
            context: $context
        ) {}
    }
}
