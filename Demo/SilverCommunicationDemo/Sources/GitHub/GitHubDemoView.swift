//
//  GitHubDemoView.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 12/03/2025.
//

import SilverCommunication
import SwiftUI

enum GitHubRequest: String, CaseIterable, Identifiable {
    case repositoryList
    case repositoryDetail
    
    // MARK: - Identifiable
    
    var id: String {
        rawValue
    }
    
    // MARK: - Internal properties
    
    var title: String {
        switch self {
        case .repositoryList:
            return "Apple repositories"
        case .repositoryDetail:
            return "Swift repository detail"
        }
    }
    
    var request: RequestContext {
        switch self {
        case .repositoryList:
            return RequestContext(
                path: "/orgs/apple/repos",
                httpMethod: .get,
                headers: ["per_page": "5"]
            )
        case .repositoryDetail:
            return RequestContext(
                path: "repos/apple/swift",
                httpMethod: .get
            )
        }
    }
}

struct GitHubDemoView: View {
    
    // MARK: - Private properties
    
    @State private var selectedRequest: GitHubRequest = .repositoryList
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 0) {
            if GitHubRequest.allCases.count > 1 {
                Picker("Request", selection: $selectedRequest) {
                    ForEach(GitHubRequest.allCases) {
                        Text($0.title)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(16)
            }
            ScrollView(.vertical) {
                ZStack {
                    switch selectedRequest {
                    case .repositoryList:
                        GitHubRepositoryListRequestView(
                            requestContext: selectedRequest.request
                        )
                    case .repositoryDetail:
                        GitHubRepositoryDetailRequestView(
                            requestContext: selectedRequest.request
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            }
        }
        .navigationTitle("GitHub")
    }
}

#Preview {
    GitHubDemoView()
}
