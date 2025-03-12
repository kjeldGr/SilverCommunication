//
//  GitHubRepositoryList.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 12/03/2025.
//

import SwiftUI

struct GitHubRepositoryListItem: View {
    
    // MARK: - Internal properties
    
    let repository: GitHubRepository
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                AsyncImage(
                    url: repository.owner.avatar
                ) { result in
                    result.image?
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: 32, height: 32)
                VStack(alignment: .leading, spacing: 4) {
                    PropertyView(
                        axis: .horizontal,
                        title: "Name",
                        value: repository.name
                    )
                    PropertyView(
                        axis: .horizontal,
                        title: "Owner",
                        value: repository.owner.name
                    )
                }
                Spacer()
                Button {
                    UIApplication.shared.open(repository.url)
                } label: {
                    Image(systemName: "arrow.up.forward.app")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
            if let description = repository.description {
                PropertyView(
                    title: "Description",
                    value: description
                )
            }
            HStack(spacing: 4) {
                PropertyView(
                    axis: .horizontal,
                    title: "Language",
                    value: repository.language
                )
                PropertyView(
                    axis: .horizontal,
                    title: "Size",
                    value: repository.size.flatMap {
                        "\($0)kB"
                    }
                )
            }
            Color.gray
                .frame(height: 0.5)
                .frame(maxWidth: .infinity)
        }
        .padding(.top, 8)
    }
}

// MARK: - Previews

#Preview {
    GitHubRepositoryListItem(
        repository: .preview
    )
}
