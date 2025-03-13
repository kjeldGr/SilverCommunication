//
//  ArrayContent.swift
//  SilverCommunicationDemo
//
//  Created by Kjeld Groot on 13/03/2025.
//

import SwiftUI

struct ArrayContent<Element, Content: View>: View {
    
    // MARK: - Internal properties
    
    @Binding var items: [Element]
    let isMutable: Bool
    let add: () -> Void
    @ViewBuilder let content: (_ index: Int) -> Content
    
    // MARK: - View
    
    var body: some View {
        ForEach(Array(items.enumerated()), id: \.offset) { index, _ in
            content(index)
            
        }
        .onDelete(perform: delete)
        .deleteDisabled(!isMutable)
        
        if isMutable {
            Button("Add", action: add)
        }
    }
    
    // MARK: - Private methods
    
    private func delete(atOffsets indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
}

// MARK: - StringArrayContent

struct StringArrayContent: View {
    
    // MARK: - Private properties
    
    @Binding private var items: [String]
    private let isMutable: Bool
    
    // MARK: - Initializers
    
    init(
        items: Binding<[String]>
    ) {
        self._items = items
        self.isMutable = true
    }
    
    init(
        items: [String]
    ) {
        self._items = .constant(items)
        self.isMutable = false
    }
    
    // MARK: - View
    
    var body: some View {
        ArrayContent(
            items: $items,
            isMutable: isMutable
        ) {
            items.append("")
        } content: { index in
            TextContent(
                "Value",
                text: Binding(
                    get: { items[index] },
                    set: { items[index] = $0 }
                ),
                isMutable: isMutable
            )
        }
    }
}

// MARK: - DictionaryItemArrayContent

struct DictionaryItemArrayContent: View {
    
    // MARK: - Private properties
    
    @Binding private var items: [DictionaryItem]
    private let isMutable: Bool
    
    // MARK: - Initializers
    
    init(
        items: Binding<[DictionaryItem]>
    ) {
        self._items = items
        self.isMutable = true
    }
    
    init(
        items: [DictionaryItem]
    ) {
        self._items = .constant(items)
        self.isMutable = false
    }
    
    // MARK: - View
    
    var body: some View {
        ArrayContent(
            items: $items,
            isMutable: isMutable
        ) {
            items.append(DictionaryItem(key: "", value: ""))
        } content: { index in
            LabeledContent {
                TextContent(
                    "Value",
                    text: Binding(
                        get: { items[index].value },
                        set: { items[index].value = $0 }
                    ),
                    isMutable: isMutable
                )
            } label: {
                TextContent(
                    "Key",
                    text: Binding(
                        get: { items[index].key },
                        set: { items[index].key = $0 }
                    ),
                    isMutable: isMutable
                )
            }
        }
    }
}

// MARK: - Previews

#Preview("Mutable (String)") {
    @Previewable @State var items: [String] = ["preview"]
    
    List {
        StringArrayContent(items: $items)
    }
}

#Preview("Immutable (String)") {
    let items: [String] = ["preview"]
    
    List {
        StringArrayContent(items: items)
    }
}

#Preview("Mutable (DictionaryItem)") {
    @Previewable @State var items: [DictionaryItem] = [
        DictionaryItem(key: "Key", value: "Value")
    ]
    
    List {
        DictionaryItemArrayContent(items: $items)
    }
}

#Preview("Immutable (DictionaryItem)") {
    let items: [DictionaryItem] = [
        DictionaryItem(key: "Key", value: "Value")
    ]
    
    List {
        DictionaryItemArrayContent(items: items)
    }
}
