//
//  GitHubRepositoryList.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 12/03/2025.
//

import SwiftUI

struct GitHubRepositoryList: View {
    
    // MARK: - Internal properties
    
    let repositories: [GitHubRepository]
    
    // MARK: - View
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(repositories) { repository in
                GitHubRepositoryListItem(repository: repository)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    GitHubRepositoryList(
        repositories: [.preview]
    )
}
