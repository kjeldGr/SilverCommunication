//
//  PropertyView.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 11/03/2025.
//

import SwiftUI

struct PropertyView<Footer: View>: View {
    
    // MARK: - Internal properties
    
    let title: String
    let footer: () -> Footer?
    
    // MARK: - Initializers
    
    init(
        title: String,
        value: String? = nil
    ) where Footer == Text {
        self.init(title: title) {
            value.flatMap { Text($0) }
        }
    }
    
    init(
        title: String,
        @ViewBuilder footer: @escaping () -> Footer?
    ) {
        self.title = title
        self.footer = footer
    }
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(title):")
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            if let footer = footer() {
                footer
            }
        }
    }
}

// MARK: - Previews

#Preview("Title") {
    PropertyView(
        title: "Title"
    )
}

#Preview("Title & Value") {
    PropertyView(
        title: "Title",
        value: "Value"
    )
}

#Preview("Title & Footer") {
    PropertyView(
        title: "Title",
        footer: {
            ZStack(alignment: .leading) {
                Color.blue
                    .frame(height: 24)
                Text("Footer")
                    .foregroundStyle(.white)
            }
        }
    )
}
