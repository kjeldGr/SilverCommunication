//
//  ContentView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SilverCommunication
import SwiftUI

struct ContentView: View {
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            List {
                Section("Demo requests") {
                    NavigationLink("HTTPBin") {
                        RequestDemoListView(
                            requests: [.get, .post, .put, .delete, .patch],
                            demoContent: requestView
                        )
                        .environmentObject(RequestManager.httpBin)
                        .navigationTitle("HTTPBin")
                    }
                    NavigationLink("GitHub") {
                        RequestDemoListView(
                            requests: [.repositoryList, .repositoryDetail],
                            demoContent: requestView
                        )
                        .environmentObject(RequestManager.gitHub)
                        .navigationTitle("GitHub")
                    }
                    NavigationLink("Mock") {
                        RequestDemoListView(
                            requests: DemoRequest.allCases,
                            demoContent: requestView
                        )
                        .environmentObject(RequestManager.mock)
                        .navigationTitle("Mock")
                    }
                }
            }
            .navigationTitle("Demo")
        }
    }
    
    // MARK: - Private methods
    
    @ViewBuilder
    private func requestView(for request: DemoRequest) -> some View {
        switch request {
        case .get, .post, .put, .delete, .patch:
            RawRequestDemoView(
                context: request.context
            )
        case .repositoryList:
            DecodableRequestDemoView(
                context: request.context
            ) { repositories in
                GitHubRepositoryList(repositories: repositories)
            }
        case .repositoryDetail:
            DecodableRequestDemoView(
                context: request.context
            ) { repository in
                GitHubRepositoryList(repositories: [repository])
            }
        }
    }
}

// MARK: - Previews

#Preview {
    ContentView()
}
