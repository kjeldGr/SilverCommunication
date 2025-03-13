//
//  RequestDemoListView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 13/03/2025.
//

import SilverCommunication
import SwiftUI

struct RequestDemoListView<Content: View>: View {
    
    // MARK: - Private properties
    
    private let requests: [DemoRequest]
    @ViewBuilder let requestView: (DemoRequest) -> Content
    @State private var selectedRequest: DemoRequest
    
    // MARK: - Initializers
    
    init(
        requests: [DemoRequest],
        @ViewBuilder requestView: @escaping (DemoRequest) -> Content
    ) {
        self.requests = requests
        self.requestView = requestView
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
                ZStack {
                    requestView(selectedRequest)
                        .id(selectedRequest)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            }
        }
    }
}

// MARK: - Preview

#Preview("Single request") {
    RequestDemoListView(
        requests: [.get]
    ) { request in
        RawRequestDemoView(
            context: request.context
        )
    }
    .environmentObject(RequestManager(
        baseURL: .httpBin,
        mockingMethod: .data(Data("preview".utf8))
    ))
}

#Preview("Multiple requests") {
    RequestDemoListView(
        requests: [.get, .post]
    ) { request in
        RawRequestDemoView(
            context: request.context
        )
    }
    .environmentObject(RequestManager(
        baseURL: .httpBin,
        mockingMethod: .data(Data("preview".utf8))
    ))
}
