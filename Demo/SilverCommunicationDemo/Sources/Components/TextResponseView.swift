//
//  TextResponseView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI

struct TextResponseView: View {
    
    // MARK: - Internal properties
    
    let data: Data
    
    // MARK: - View
    
    var body: some View {
        Section("Content") {
            Text(String(decoding: data, as: UTF8.self))
        }
    }
}

// MARK: - Previews

#Preview {
    List {
        TextResponseView(
            data: Data("{\"key\": \"value\"}".utf8)
        )
    }
}
