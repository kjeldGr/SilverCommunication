//
//  RequestDemoView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI
import SilverCommunication

struct DemoRequestContext: Identifiable, Equatable, Hashable {
    var id: String {
        "\(httpMethod.rawValue)_\(title)_\(path)"
    }
    
    let title: String
    let path: String
    let httpMethod: Request.HTTPMethod
    var queryParameters: [String: String] = [String: String]()
    var headers: [String: String] = [String: String]()
}

struct RequestDemoView: View {
    
    // MARK: - Internal properties
    
    let requests: [DemoRequestContext]
    
    // MARK: - Private properties
    
    @EnvironmentObject private var requestManager: RequestManager
    
    @State private var selectedRequest: DemoRequestContext
    @State private var httpBody: HTTPBody?
    @State private var response: Response<Data?>?
    
    // MARK: - Initializers
    
    init(requests: [DemoRequestContext]) {
        self.requests = requests
        self._selectedRequest = State(initialValue: requests[0])
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 0) {
            if requests.count > 1 {
                Picker("Request", selection: $selectedRequest) {
                    ForEach(requests) {
                        Text($0.title)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(16)
            }
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 24) {
                    PropertyView(
                        title: "Base URL",
                        value: requestManager.baseURL.absoluteString
                    )
                    PropertyView(
                        title: "Path",
                        value: selectedRequest.path
                    )
                    MutableDictionaryPropertyView(
                        title: "Query Parameters",
                        dictionary: $selectedRequest.queryParameters
                    )
                    MutableDictionaryPropertyView(
                        title: "Request Headers",
                        dictionary: $selectedRequest.headers
                    )
                    if selectedRequest.httpMethod.isHTTPBodyFieldVisible {
                        HTTPBodyView(httpBody: $httpBody)
                    }
                    Button("Perform request") {
                        performRequest()
                    }
                    .buttonStyle(.bordered)
                    RequestResponseView(
                        response: $response
                    ) { content in
                        if let content {
                            TextResponseView(data: content)
                        }
                    }
                }
                .padding(16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onChange(of: selectedRequest) { _, newValue in
            if !newValue.httpMethod.isHTTPBodyFieldVisible {
                httpBody = nil
            }
            response = nil
        }
    }
    
    // MARK: - Private methods
    
    private func performRequest() {
        Task {
            do {
                response = try await requestManager.perform(
                    request: Request(
                        httpMethod: selectedRequest.httpMethod,
                        path: selectedRequest.path,
                        parameters: selectedRequest.queryParameters,
                        headers: selectedRequest.headers,
                        body: httpBody
                    )
                )
            } catch {
                // TODO: Handle error
            }
        }
    }
}

// MARK: - HTTPMethod+HTTPBody

private extension Request.HTTPMethod {
    var isHTTPBodyFieldVisible: Bool {
        switch self {
        case .get:
            return false
        default:
            return true
        }
    }
}

// TODO: Fix preview
//#Preview {
//    RequestExampleView()
//}
