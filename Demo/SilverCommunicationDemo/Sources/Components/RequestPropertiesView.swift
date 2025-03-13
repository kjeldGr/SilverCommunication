//
//  RequestPropertiesView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 12/03/2025.
//

import SilverCommunication
import SwiftUI

struct RequestPropertiesView: View {
    
    // MARK: - Internal properties
    
    @Binding var context: RequestContext
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PropertyView(
                title: "Path",
                value: context.path
            )
            MutableDictionaryPropertyView(
                title: "Query Parameters",
                dictionary: $context.queryParameters
            )
            MutableDictionaryPropertyView(
                title: "Request Headers",
                dictionary: $context.headers
            )
            if context.httpMethod.isHTTPBodyFieldVisible {
                HTTPBodyView(httpBody: $context.httpBody)
            }
        }
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
        path: "/get",
        httpMethod: .get
    )
    RequestPropertiesView(
        context: $context
    )
}

#Preview("POST") {
    @Previewable @State var context: RequestContext = RequestContext(
        path: "/post",
        httpMethod: .post
    )
    RequestPropertiesView(
        context: $context
    )
}
