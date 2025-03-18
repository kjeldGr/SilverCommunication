//
//  GitHubRepositoryList.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 12/03/2025.
//

import SwiftUI

struct GitHubRepositoryList: View {
    
    // MARK: - Internal properties
    
    let repositories: [GitHubRepository]
    
    // MARK: - View
    
    var body: some View {
        ForEach(repositories) { repository in
            Section(repository.name) {
                LabeledContent("Owner") {
                    HStack {
                        AsyncImage(
                            url: repository.owner.avatar
                        ) { result in
                            result.image?
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 32, height: 32)
                        
                        Text(repository.owner.name)
                    }
                }
                if let description = repository.description {
                    LabeledContent("Description", value: description)
                }
                if let language = repository.language {
                    LabeledContent("Language", value: "\(language)")
                }
                if let size = repository.size {
                    LabeledContent("Size", value: "\(size)kB")
                }
                LabeledContent("URL") {
                    Button(repository.url.absoluteString) {
                        #if os(macOS)
                        NSWorkspace.shared.open(repository.url)
                        #elseif os(iOS)
                        UIApplication.shared.open(repository.url)
                        #endif
                    }
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    List {
        GitHubRepositoryList(
            repositories: [.preview]
        )
    }
}
