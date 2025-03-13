//
//  DemoRequest.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 13/03/2025.
//

enum DemoRequest: String, Identifiable {
    
    // MARK: - HTTPBin
    
    case get
    case post
    case put
    case delete
    case patch
    
    // MARK: - GitHub
    
    case repositoryList
    case repositoryDetail
    
    // MARK: - Identifiable
    
    var id: String { rawValue }
    
    // MARK: - Internal properties
    
    var title: String {
        switch self {
        case .get, .post, .put, .delete, .patch:
            return rawValue.uppercased()
        case .repositoryList:
            return "Apple Repositories"
        case .repositoryDetail:
            return "Swift repository detail"
        }
    }
    
    var context: RequestContext {
        switch self {
        case .get:
            return RequestContext(path: "/get", httpMethod: .get)
        case .post:
            return RequestContext(path: "/post", httpMethod: .post)
        case .put:
            return RequestContext(path: "/put", httpMethod: .put)
        case .delete:
            return RequestContext(path: "/delete", httpMethod: .delete)
        case .patch:
            return RequestContext(path: "/patch", httpMethod: .patch)
        case .repositoryList:
            return RequestContext(path: "/orgs/apple/repos", httpMethod: .get, queryParameters: [DictionaryItem(key: "per_page", value: "10")])
        case .repositoryDetail:
            return RequestContext(path: "repos/apple/swift", httpMethod: .get)
        }
    }
}
