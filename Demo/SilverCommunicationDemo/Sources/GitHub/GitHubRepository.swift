//
//  GitHubRepository.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 12/03/2025.
//

import Foundation

struct GitHubRepository: Identifiable, Codable {
    
    // MARK: - Owner
    
    struct Owner: Identifiable, Codable {
        let id: Int
        let name: String
        let avatar: URL?
        
        // MARK: - CodingKeys
        
        private enum CodingKeys: String, CodingKey {
            case id
            case name = "login"
            case avatar = "avatar_url"
        }
    }
    
    let id: Int
    let owner: Owner
    let url: URL
    let name: String
    let description: String?
    let language: String?
    let size: Int?
    
    // MARK: - CodingKeys
    
    private enum CodingKeys: String, CodingKey {
        case id
        case owner
        case url = "html_url"
        case name
        case description
        case language
        case size
    }
}

// MARK: - Preview mocks

extension GitHubRepository {
    static let preview: GitHubRepository = GitHubRepository(
        id: 0,
        owner: GitHubRepository.Owner(
            id: 0,
            name: "Preview",
            avatar: nil
        ),
        url: URL(string: "https://github.com")!,
        name: "Preview",
        description: "Preview",
        language: "Swift",
        size: 100
    )
}
