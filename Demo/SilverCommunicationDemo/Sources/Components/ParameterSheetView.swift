//
//  ParameterSheetView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI

struct ParameterSheetView: View {
    
    // MARK: - Internal properties
    
    let title: String
    @Binding var isPresented: Bool
    @Binding var parameters: [String: String]
    
    // MARK: - Private properties
    
    @State private var key: String = ""
    @State private var value: String = ""
    
    // MARK: - View
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 24
        ) {
            Text(title)
                .font(.title)
            Spacer()
            VStack(alignment: .leading, spacing: 12) {
                PropertyView(
                    title: "Key"
                ) {
                    TextField("Key", text: $key)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                PropertyView(
                    title: "Value"
                ) {
                    TextField("Value", text: $value)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button("Add") {
                    guard !key.isEmpty, !value.isEmpty else {
                        return
                    }
                    parameters[key] = value
                    isPresented = false
                }
                .buttonStyle(.bordered)
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}

// MARK: - Previews

#Preview {
    @Previewable @State var parameters: [String: String] = [String: String]()
    @Previewable @State var isPresented: Bool = true
    
    ParameterSheetView(
        title: "Add parameter",
        isPresented: $isPresented,
        parameters: $parameters
    )
}
