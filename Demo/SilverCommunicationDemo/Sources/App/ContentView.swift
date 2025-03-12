//
//  ContentView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SilverCommunication
import SwiftUI

struct ContentView: View {
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            List {
                Section("SilverCommunication Demo's") {
                    NavigationLink("HTTPBin") {
                        HTTPBinDemoView()
                            .environmentObject(RequestManager(baseURL: Constants.httpBinBaseURL))
                    }
                    NavigationLink("GitHub") {
                        GitHubDemoView()
                            .environmentObject(RequestManager(baseURL: Constants.gitHubBaseURL))
                    }
                }
            }
            .navigationTitle("Demo")
        }
    }
}

// TODO: Fix Preview with Environment object
//#Preview {
//    ContentView()
//}
