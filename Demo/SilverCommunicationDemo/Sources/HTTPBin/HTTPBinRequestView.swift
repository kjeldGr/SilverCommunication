//
//  HTTPBinRequestView.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 13/03/2025.
//

import SilverCommunication
import SwiftUI

struct HTTPBinRequestView: View {
    
    // MARK: - Internal properties
    
    @State var requestContext: RequestContext
    
    // MARK: - Private properties
    
    @EnvironmentObject private var requestManager: RequestManager
    @State private var response: Response<Data?>?
    
    // MARK: - View
    
    var body: some View {
        RequestView(
            baseURL: requestManager.baseURL,
            requestContext: $requestContext,
            performRequestAction: performRequest
        ) {
            RequestResponseView(
                response: response
            ) { data in
                TextResponseView(data: data)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func performRequest() {
        Task { @MainActor in
            do {
                response = try await requestManager.perform(
                    request: requestContext.request
                )
            } catch {
                // TODO: Handle error
            }
        }
    }
}

#Preview {
    HTTPBinRequestView(
        requestContext: RequestContext(
            path: "/preview",
            httpMethod: .get
        )
    )
    .environmentObject(RequestManager(
        baseURL: Constants.httpBinBaseURL,
        mockingMethod: .data(Data("preview".utf8))
    ))
}
