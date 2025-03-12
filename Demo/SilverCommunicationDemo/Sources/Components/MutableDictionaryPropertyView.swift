//
//  MutableDictionaryPropertyView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI

struct MutableDictionaryPropertyView: View {
    
    // MARK: - Internal properties
    
    let title: String
    @Binding var dictionary: [String: String]
    
    // MARK: - Private properties
    
    @State private var isParameterSheetPresented: Bool = false
    
    // MARK: - View
    
    var body: some View {
        PropertyView(
            title: title
        ) {
            ForEach(Array(dictionary.keys.sorted()), id: \.self) { key in
                PropertyView(
                    axis: .horizontal,
                    title: key
                ) {
                    if let value = dictionary[key] {
                        Text(value)
                    }
                    Spacer()
                    Button("delete", role: .destructive) {
                        dictionary.removeValue(forKey: key)
                    }
                }
            }
            Button("Add \(title)") {
                isParameterSheetPresented.toggle()
            }
        }
        .sheet(isPresented: $isParameterSheetPresented) {
            ParameterSheetView(
                title: "Add \(title)",
                isPresented: $isParameterSheetPresented,
                parameters: $dictionary
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var dictionary: [String: String] = [String: String]()
    
    MutableDictionaryPropertyView(
        title: "Parameters",
        dictionary: $dictionary
    )
}
