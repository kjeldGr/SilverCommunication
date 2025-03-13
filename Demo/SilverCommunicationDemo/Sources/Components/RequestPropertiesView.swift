//
//  RequestPropertiesView.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 12/03/2025.
//

import SilverCommunication
import SwiftUI

struct RequestPropertiesView: View {
    
    // MARK: - Internal properties
    
    @Binding var request: RequestContext
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            PropertyView(
                title: "Path",
                value: request.path
            )
            MutableDictionaryPropertyView(
                title: "Query Parameters",
                dictionary: $request.queryParameters
            )
            MutableDictionaryPropertyView(
                title: "Request Headers",
                dictionary: $request.headers
            )
            if request.httpMethod.isHTTPBodyFieldVisible {
                HTTPBodyView(httpBody: $request.httpBody)
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
    @Previewable @State var request: RequestContext = RequestContext(
        path: "/get",
        httpMethod: .get
    )
    RequestPropertiesView(
        request: $request
    )
}

#Preview("POST") {
    @Previewable @State var request: RequestContext = RequestContext(
        path: "/post",
        httpMethod: .post
    )
    RequestPropertiesView(
        request: $request
    )
}
