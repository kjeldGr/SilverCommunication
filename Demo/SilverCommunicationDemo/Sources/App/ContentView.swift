//
//  ContentView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SilverCommunication
import SwiftUI

struct ContentView: View {
    
    // MARK: - Private properties
    
    @State private var httpMethod: Request.HTTPMethod = .get
    
    // MARK: - View
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("HTTP Method", selection: $httpMethod) {
                    ForEach(Constants.availableHTTPMethods, id: \.self) {
                        Text($0.rawValue)
                            .tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                ScrollView(.vertical) {
                    RequestExampleView(httpMethod: httpMethod)
                        .padding(16)
                }
            }
            .navigationTitle("SilverCommunication")
        }
    }
}

// TODO: Fix Preview with Environment object
//#Preview {
//    ContentView()
//}
