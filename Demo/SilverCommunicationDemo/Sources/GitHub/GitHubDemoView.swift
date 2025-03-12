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
    
    @EnvironmentObject private var requestManager: RequestManager
    
    // MARK: - View
    
    var body: some View {
        RequestDemoView(
            viewModel: GitHubDemoViewModel(
                requestManager: requestManager,
                requests: [
                    DemoRequestContext(
                        title: "Apple Repositories",
                        path: "/orgs/apple/repos",
                        httpMethod: .get,
                        queryParameters: ["per_page": "5"]
                    )
                ]
            )
        ) { response in
            RequestResponseView(
                response: response
            ) { repositories in
                GitHubRepositoryList(repositories: repositories)
            }
        }
        .navigationTitle("GitHub")
    }
}

#Preview {
    GitHubDemoView()
}
