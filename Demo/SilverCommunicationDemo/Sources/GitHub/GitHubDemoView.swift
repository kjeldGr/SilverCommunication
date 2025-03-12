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
    
    // MARK: - View
    
    var body: some View {
        RequestDemoView(
            requests: [
                DemoRequestContext(
                    title: "Apple Repositories",
                    path: "/orgs/apple/repos",
                    httpMethod: .get,
                    queryParameters: ["per_page": "5"]
                )
            ]
        )
        .navigationTitle("GitHub API")
        .environmentObject(requestManager)
    }
}

#Preview {
    GitHubDemoView()
}
