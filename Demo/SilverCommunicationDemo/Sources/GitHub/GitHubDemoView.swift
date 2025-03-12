//
//  GitHubDemoView.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 12/03/2025.
//

import SilverCommunication
import SwiftUI

struct GitHubDemoView: View {
    
    // MARK: - Private properties
    
    @State private var requestManager: RequestManager = RequestManager(
        baseURL: URL(string: "https://api.github.com")!
    )
    private static let requests: [DemoRequestContext] = [
        DemoRequestContext(
            title: "Apple Repositories",
            path: "/orgs/apple/repos",
            httpMethod: .get,
            queryParameters: ["per_page": "5"]
        )
    ]
    
    // MARK: - View
    
    var body: some View {
        RequestDemoView(
            viewModel: GitHubDemoViewModel(
                requestManager: requestManager,
                requests: Self.requests
            )
        ) { response in
            RequestResponseView(
                response: response
            ) { repositories in
                GitHubRepositoryList(repositories: repositories)
            }
        }
        .navigationTitle("GitHub API")
        .environmentObject(requestManager)
    }
}

#Preview {
    GitHubDemoView()
}
