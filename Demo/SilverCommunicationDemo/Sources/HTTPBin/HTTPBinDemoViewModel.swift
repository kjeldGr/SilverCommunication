//
//  HTTPBinDemoViewModel.swift
//  SilverCommunicationDemo
//
//  Created by KPGroot on 12/03/2025.
//

import Foundation
import SilverCommunication

final class HTTPBinDemoViewModel: RequestDemoViewModel {
    
    // MARK: - Initializers
    
    init(
        requestManager: RequestManager,
        requests: [DemoRequestContext]
    ) {
        self.requestManager = requestManager
        self.requests = requests
        self.selectedRequest = requests[0]
    }
    
    // MARK: - RequestDemoViewModel
    
    let requestManager: RequestManager
    let requests: [DemoRequestContext]
    @Published var selectedRequest: DemoRequestContext
    @Published var response: Response<Data?>?
    
    func performRequest() {
        Task { @MainActor in
            do {
                response = try await requestManager.perform(request: selectedRequest.request)
            } catch {
                // TODO: Handle error
                debugPrint(error)
            }
        }
    }
}
