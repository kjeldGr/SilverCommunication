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
        RequestView(
            baseURL: requestManager.baseURL,
            context: $context,
            performRequestAction: performRequest
        )
        if let response {
            RequestResponseView(
                statusCode: response.statusCode,
                headers: response.headers
            ) {
                TextResponseView(data: response.content)
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
                debugPrint(error)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    List {
        RawRequestDemoView(
            context: RequestContext(
                path: "/preview",
                httpMethod: .get
            )
        )
    }
    .environmentObject(RequestManager(
        baseURL: .httpBin,
        mockingMethod: .data(Data("preview".utf8))
    ))
}
