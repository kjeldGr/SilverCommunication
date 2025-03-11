//
//  SilverCommunicationDemoApp.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SilverCommunication
import SwiftUI

@main
struct SilverCommunicationDemoApp: App {
    
    // MARK: - Private properties
    
    @State private var requestManager: RequestManager = RequestManager(baseURL: URL(string: "https://httpbin.org")!)
    
    // MARK: - App
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(requestManager)
        }
    }
}
