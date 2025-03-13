//
//  GitHubRepositoryDetailRequestView.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 13/03/2025.
//

import SilverCommunication
import SwiftUI

struct GitHubRepositoryDetailRequestView: View {
    
    // MARK: - Internal properties
    
    @State var requestContext: RequestContext
    
    // MARK: - Private properties
    
    @EnvironmentObject private var requestManager: RequestManager
    @State private var response: Response<GitHubRepository>?
    
    // MARK: - View
    
    var body: some View {
        RequestView(
            baseURL: requestManager.baseURL,
            requestContext: $requestContext,
            performRequestAction: performRequest
        ) {
            RequestResponseView(
                response: response
            ) { repository in
                GitHubRepositoryList(
                    repositories: [repository]
                )
            }
        }
    }
    
    // MARK: - Private methods
    
    private func performRequest() {
        Task { @MainActor in
            do {
                response = try await requestManager.perform(
                    request: requestContext.request,
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
    GitHubRepositoryDetailRequestView(
        requestContext: RequestContext(
            path: "/preview",
            httpMethod: .get
        )
    )
    .environmentObject(RequestManager(
        baseURL: Constants.gitHubBaseURL,
        mockingMethod: .encodable(GitHubRepository.preview)
    ))
}
