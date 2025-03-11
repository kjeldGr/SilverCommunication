//
//  RequestExampleView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI
import SilverCommunication

struct RequestExampleView: View {
    
    // MARK: - Internal properties
    
    let httpMethod: Request.HTTPMethod
    
    // MARK: - Private properties
    
    @EnvironmentObject private var requestManager: RequestManager
    @State private var response: Response<Data?>?
    private var path: String {
        switch httpMethod {
        case .get:
            return "/get"
        case .post:
            return "/post"
        case .put:
            return "/put"
        case .delete:
            return "/delete"
        case .patch:
            return "/patch"
        default:
            return "/anything/\(httpMethod.rawValue)"
        }
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PropertyView(
                title: "Base URL",
                value: requestManager.baseURL.absoluteString
            )
            PropertyView(
                title: "Path",
                value: path
            )
            HStack {
                Button("Perform request") {
                    performRequest()
                }
            }
            RequestResponseView(
                response: $response
            )
        }
    }
    
    private func performRequest() {
        Task {
            do {
                response = try await requestManager.perform(
                    request: Request(
                        httpMethod: httpMethod,
                        path: path
                    )
                )
            } catch {
                // TODO: Handle error
            }
        }
    }
}

// TODO: Fix preview
//#Preview {
//    RequestExampleView()
//}
