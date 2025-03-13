//
//  RawRequestDemoView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 13/03/2025.
//

import SilverCommunication
import SwiftUI

struct RawRequestDemoView: View {
    
    // MARK: - Internal properties
    
    @State var context: RequestContext
    
    // MARK: - Private properties
    
    @EnvironmentObject private var requestManager: RequestManager
    @State private var response: Response<Data?>?
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            RequestView(
                baseURL: requestManager.baseURL,
                context: $context,
                performRequestAction: performRequest
            )
            RequestResponseView(
                response: response
            ) { data in
                TextResponseView(data: data)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func performRequest() {
        Task { @MainActor in
            do {
                response = try await requestManager.perform(
                    request: context.request
                )
            } catch {
                // TODO: Handle error
            }
        }
    }
}

// MARK: - Previews

#Preview {
    RawRequestDemoView(
        context: RequestContext(
            path: "/preview",
            httpMethod: .get
        )
    )
    .environmentObject(RequestManager(
        baseURL: .httpBin,
        mockingMethod: .data(Data("preview".utf8))
    ))
}
