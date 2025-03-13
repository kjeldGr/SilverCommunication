//
//  HTTPBinDemoView.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 12/03/2025.
//

import SilverCommunication
import SwiftUI

enum HTTPBinRequest: String, CaseIterable, Identifiable {
    case get
    case post
    case put
    case delete
    case patch
    
    // MARK: - Identifiable
    
    var id: String {
        rawValue
    }
    
    // MARK: - Internal properties
    
    var title: String {
        rawValue.uppercased()
    }
    
    var requestContext: RequestContext {
        RequestContext(
            path: "/\(rawValue)",
            httpMethod: httpMethod
        )
    }
    
    private var httpMethod: Request.HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        case .patch:
            return .patch
        }
    }
}

struct HTTPBinDemoView: View {
    
    // MARK: - Private properties
    
    @State private var selectedRequest: HTTPBinRequest = .get
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 0) {
            if HTTPBinRequest.allCases.count > 1 {
                Picker("Request", selection: $selectedRequest) {
                    ForEach(HTTPBinRequest.allCases) {
                        Text($0.title)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(16)
            }
            ScrollView(.vertical) {
                HTTPBinRequestView(
                    requestContext: selectedRequest.requestContext
                )
                .id(selectedRequest)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            }
        }
        .navigationTitle("HTTPBin")
    }
}

// MARK: - Previews

#Preview {
    HTTPBinDemoView()
}
