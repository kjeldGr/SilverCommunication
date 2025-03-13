//
//  TextContent.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 13/03/2025.
//

import SwiftUI

struct TextContent: View {
    
    // MARK: - Private properties
    
    private let titleKey: String
    @Binding private var text: String
    private let isMutable: Bool
    
    // MARK: - Initializers
    
    init(
        _ titleKey: String,
        text: Binding<String>
    ) {
        self.init(titleKey, text: text, isMutable: true)
    }
    
    init(
        _ titleKey: String,
        text: String
    ) {
        self.init(
            titleKey,
            text: .constant(text),
            isMutable: false
        )
    }
    
    init(
        _ titleKey: String,
        text: Binding<String>,
        isMutable: Bool
    ) {
        self.titleKey = titleKey
        self._text = text
        self.isMutable = isMutable
    }
    
    // MARK: - View
    
    var body: some View {
        if isMutable {
            TextField(titleKey, text: $text)
                .autocorrectionDisabled()
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif
        } else {
            Text(text)
        }
    }
}

// MARK: - Previews

#Preview("Mutable") {
    @Previewable @State var text = "preview"
    
    TextContent("Preview", text: $text)
}

#Preview("Immutable") {
    let text = "preview"
    
    TextContent("Preview", text: text)
}
