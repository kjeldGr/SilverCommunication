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
    @State private var selectedRequest: DemoRequest
    @ViewBuilder let demoContent: (DemoRequest) -> Content
    
    // MARK: - Initializers
    
    init(
        requests: [DemoRequest],
        @ViewBuilder demoContent: @escaping (DemoRequest) -> Content
    ) {
        self.requests = requests
        self.demoContent = demoContent
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
                #if os(watchOS)
                .pickerStyle(.wheel)
                #else
                .pickerStyle(.segmented)
                #endif
                .padding(16)
            }
            demoContent(selectedRequest)
                .id(selectedRequest)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Preview

#Preview("Single request") {
    RequestDemoListView(
        requests: [.get]
    ) { request in
        RawRequestDemoView(context: request.context)
    }
    .environmentObject(RequestManager.mock)
}

#Preview("Multiple requests") {
    RequestDemoListView(
        requests: [.get, .post]
    ) { request in
        RawRequestDemoView(context: request.context)
    }
    .environmentObject(RequestManager.mock)
}
