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
        "\(httpMethod.rawValue)_\(path)"
    }
    
    let title: String
    let path: String
    let httpMethod: Request.HTTPMethod
    var queryParameters: [String: String] = [String: String]()
    var headers: [String: String] = [String: String]()
    var httpBody: HTTPBody?
    
    var request: Request {
        Request(
            httpMethod: httpMethod,
            path: path,
            parameters: queryParameters,
            headers: headers,
            body: httpBody
        )
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(path)
        hasher.combine(httpMethod)
    }
}

protocol RequestDemoViewModel: ObservableObject {
    associatedtype ContentType
    
    var requestManager: RequestManager { get }
    var requests: [DemoRequestContext] { get }
    var selectedRequest: DemoRequestContext { get set }
    var response: Response<ContentType>? { get }
    
    func performRequest()
}

struct RequestDemoView<ViewModel: RequestDemoViewModel, ResponseView: View>: View {
    
    // MARK: - Internal properties
    
    @StateObject var viewModel: ViewModel
    @ViewBuilder let response: (Response<ViewModel.ContentType>?) -> ResponseView
    
    // MARK: - View
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.requests.count > 1 {
                Picker("Request", selection: $viewModel.selectedRequest) {
                    ForEach(viewModel.requests) {
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
                        value: viewModel.requestManager.baseURL.absoluteString
                    )
                    PropertyView(
                        title: "Path",
                        value: viewModel.selectedRequest.path
                    )
                    MutableDictionaryPropertyView(
                        title: "Query Parameters",
                        dictionary: $viewModel.selectedRequest.queryParameters
                    )
                    MutableDictionaryPropertyView(
                        title: "Request Headers",
                        dictionary: $viewModel.selectedRequest.headers
                    )
                    if viewModel.selectedRequest.httpMethod.isHTTPBodyFieldVisible {
                        HTTPBodyView(httpBody: $viewModel.selectedRequest.httpBody)
                    }
                    Button("Perform request") {
                        viewModel.performRequest()
                    }
                    .buttonStyle(.bordered)
                    response(viewModel.response)
                }
                .padding(16)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        // TODO: Move to ViewModel
//        .onChange(of: viewModel.selectedRequest) { _, newValue in
//            if !newValue.httpMethod.isHTTPBodyFieldVisible {
//                viewModel.selectedRequest.httpBody = nil
//            }
////            response = nil
//        }
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
