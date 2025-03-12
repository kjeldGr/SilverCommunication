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
    
    static private let requests: [DemoRequestContext] = [
        Request.HTTPMethod.get, .post, .put, .delete, .patch
    ].map {
        DemoRequestContext(
            title: $0.rawValue,
            path: "/\($0.rawValue.lowercased())",
            httpMethod: $0
        )
    }
    
    // MARK: - View
    
    var body: some View {
        RequestDemoView(
            viewModel: HTTPBinDemoViewModel(
                requestManager: requestManager,
                requests: Self.requests)
        ) { response in
            RequestResponseView(
                response: response
            ) { data in
                TextResponseView(data: data)
            }
        }
        .navigationTitle("HTTPBin API")
        // TODO: Move to ContentView
//        .environmentObject(requestManager)
    }
}

// MARK: - Previews

#Preview {
    HTTPBinDemoView()
}
