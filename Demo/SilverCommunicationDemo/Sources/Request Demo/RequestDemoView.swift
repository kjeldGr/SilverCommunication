//
//  RequestDemoView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 13/03/2025.
//

import SilverCommunication
import SwiftUI

struct PresentableError: LocalizedError {
    let error: Error
    
    var errorDescription: String? {
        String(describing: error)
    }
}

struct RequestDemoView<ContentType, ResponseContent: View>: View {
    
    // MARK: - Internal properties
    
    @Binding var context: RequestContext
    let performRequest: () async throws -> Response<ContentType>
    @ViewBuilder let responseContent: (ContentType) -> ResponseContent
    
    // MARK: - Private properties
    
    @EnvironmentObject private var requestManager: RequestManager
    @State private var isLoading: Bool = false
    @State private var error: PresentableError?
    @State var response: Response<ContentType>?
    
    // MARK: - View
    
    var body: some View {
        List {
            RequestView(
                baseURL: requestManager.baseURL,
                context: $context,
                performRequest: performAsyncRequest
            )
            if let response {
                RequestResponseView(
                    statusCode: response.statusCode,
                    headers: response.headers
                ) {
                    responseContent(response.content)
                }
            }
        }
        .alert(
            isPresented: Binding(
                get: { error != nil },
                set: { isPresented in
                    if !isPresented {
                        error = nil
                    }
                }
            ),
            error: error
        ) {}
        .overlay {
            if isLoading {
                ProgressView("Loading")
                    .progressViewStyle(.circular)
                    .padding(16)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 8
                        )
                        .fill(.fill)
                        .aspectRatio(1, contentMode: .fill)
                    )
            }
        }
    }
    
    private func performAsyncRequest() {
        isLoading = true
        Task { @MainActor in
            do {
                response = try await performRequest()
            } catch {
                self.error = PresentableError(error: error)
            }
            isLoading = false
        }
    }
}

struct RawRequestDemoView: View {
    
    // MARK: - Internal properties
    
    @State var context: RequestContext
    
    // MARK: - Private properties
    
    @EnvironmentObject private var requestManager: RequestManager
    
    // MARK: - View
    
    var body: some View {
        RequestDemoView(
            context: $context,
            performRequest: {
                try await requestManager.perform(
                    request: context.request
                )
            }
        ) { content in
            if let content {
                TextResponseView(data: content)
            }
        }
    }
}

struct DecodableRequestDemoView<ContentType: Decodable, ResponseContent: View>: View {
    
    // MARK: - Internal properties
    
    @State var context: RequestContext
    @ViewBuilder var responseContent: (ContentType) -> ResponseContent
    
    // MARK: - Private properties
    
    @EnvironmentObject private var requestManager: RequestManager
    
    // MARK: - View
    
    var body: some View {
        RequestDemoView(
            context: $context,
            performRequest: {
                try await requestManager.perform(
                    request: context.request,
                    parser: DecodableParser()
                )
            },
            responseContent: responseContent
        )
    }
}

// MARK: - Previews

#Preview("Raw Request Demo") {
    RawRequestDemoView(
        context: RequestContext(path: "/path", httpMethod: .get)
    )
    .environmentObject(
        RequestManager(
            baseURL: .httpBin,
            mockingMethod: .data(Data("Response".utf8))
        )
    )
}

#Preview("Decodable Request Demo") {
    DecodableRequestDemoView(
        context: RequestContext(path: "/path", httpMethod: .get)
    ) { content in
        GitHubRepositoryList(repositories: content)
    }
    .environmentObject(RequestManager(
        baseURL: .gitHub,
        mockingMethod: .encodable([GitHubRepository.preview])
    ))
}
