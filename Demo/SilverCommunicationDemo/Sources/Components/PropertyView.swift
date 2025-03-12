//
//  PropertyView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI

struct PropertyView<Value: View>: View {
    
    // MARK: - Internal properties
    
    let axis: Axis
    let title: String
    let value: () -> Value?
    
    // MARK: - Initializers
    
    init(
        axis: Axis = .vertical,
        title: String,
        value: String? = nil
    ) where Value == Text {
        self.init(axis: axis, title: title) {
            value.flatMap {
                Text($0)
                    .font(.body)
            }
        }
    }
    
    init(
        axis: Axis = .vertical,
        title: String,
        @ViewBuilder value: @escaping () -> Value?
    ) {
        self.axis = axis
        self.title = title
        self.value = value
    }
    
    // MARK: - View
    
    var body: some View {
        stack(axis: axis) {
            Text("\(title):")
                .font(.headline)
            value()
        }
    }
    
    @ViewBuilder
    private func stack<Content: View>(
        axis: Axis,
        @ViewBuilder content: () -> Content
    ) -> some View {
        switch axis {
        case .horizontal:
            HStack(
                alignment: .center,
                spacing: 4,
                content: content
            )
        case .vertical:
            VStack(
                alignment: .leading,
                spacing: 4,
                content: content
            )
        }
    }
}

// MARK: - Previews

#Preview("Title") {
    PropertyView(
        title: "Title"
    )
}

#Preview("Title & Text Value") {
    PropertyView(
        title: "Title",
        value: "Value"
    )
}

#Preview("Title & Custom Value View") {
    PropertyView(
        title: "Title",
        value: {
            ZStack(alignment: .leading) {
                Color.blue
                    .frame(height: 24)
                Text("Footer")
                    .foregroundStyle(.white)
            }
        }
    )
}
