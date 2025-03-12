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
    
    @EnvironmentObject private var requestManager: RequestManager
    
    // MARK: - View
    
    var body: some View {
        RequestDemoView(
            viewModel: HTTPBinDemoViewModel(
                requestManager: requestManager,
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
        ) { response in
            RequestResponseView(
                response: response
            ) { data in
                TextResponseView(data: data)
            }
        }
        .navigationTitle("HTTPBin")
    }
}

// MARK: - Previews

#Preview {
    HTTPBinDemoView()
}
