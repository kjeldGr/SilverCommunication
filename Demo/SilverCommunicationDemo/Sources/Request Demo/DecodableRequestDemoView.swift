//
//  DecodableRequestDemoView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 13/03/2025.
//

import SilverCommunication
import SwiftUI

struct DecodableRequestDemoView<ContentType: Decodable, ResponseView: View>: View {
    
    // MARK: - Internal properties
    
    @State var context: RequestContext
    @ViewBuilder var responseView: (ContentType) -> ResponseView
    
    // MARK: - Private properties
    
    @EnvironmentObject private var requestManager: RequestManager
    @State private var response: Response<ContentType>?
    
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
            ) { content in
                responseView(content)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func performRequest() {
        Task { @MainActor in
            do {
                response = try await requestManager.perform(
                    request: context.request,
                    parser: DecodableParser()
                )
            } catch {
                // TODO: Handle error
            }
        }
    }
}

// MARK: - Previews

#Preview {
    DecodableRequestDemoView(
        context: RequestContext(
            path: "/preview",
            httpMethod: .get
        )
    ) { (text: String) in
        Text(text)
    }
    .environmentObject(RequestManager(
        baseURL: .gitHub,
        mockingMethod: .encodable([GitHubRepository.preview])
    ))
}
