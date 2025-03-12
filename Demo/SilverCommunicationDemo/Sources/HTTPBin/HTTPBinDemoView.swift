//
//  HTTPBinDemoView.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 12/03/2025.
//

import SilverCommunication
import SwiftUI

struct HTTPBinDemoView: View {
    
    // MARK: - Private properties
    
    @State private var requestManager: RequestManager = RequestManager(
        baseURL: URL(string: "https://httpbin.org")!
    )
    
    // MARK: - View
    
    var body: some View {
        RequestDemoView(
            requests: [
                Request.HTTPMethod.get, .post, .put, .delete, .patch
            ].map {
                DemoRequestContext(
                    title: $0.rawValue,
                    path: "/\($0.rawValue.lowercased())",
                    httpMethod: $0
                )
            }
        )
        .navigationTitle("HTTPBin API")
        .environmentObject(requestManager)
    }
}

// MARK: - Previews

#Preview {
    HTTPBinDemoView()
}
