//
//  ContentView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            List {
                Section("SilverCommunication Demo's") {
                    NavigationLink("HTTPBin") {
                        HTTPBinDemoView()
                    }
                    NavigationLink("GitHub") {
                        GitHubDemoView()
                    }
                    NavigationLink("Custom API") {
                        EmptyView()
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
