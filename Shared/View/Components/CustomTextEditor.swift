//
//  CustomTextEditor.swift
//  Tricks
//
//  Created by Armin on 4/22/22.
//

import SwiftUI

struct CustomTextEditor: View {
    
    @State var placeholder: String
    @Binding var context: String
    @FocusState private var isFieldFocused: Bool
        
    init(placeholder: String, context: Binding<String>) {
        self.placeholder = placeholder
        self._context = context
        #if os(iOS)
        UITextView.appearance().backgroundColor = .clear
        #endif
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if context.isEmpty {
                Text(placeholder)
                    #if os(iOS)
                    .foregroundColor(Color(UIColor.placeholderText))
                    .padding(.vertical, 12)
                    #elseif os(macOS)
                    .foregroundColor(Color(NSColor.placeholderTextColor))
                    .padding(.vertical, 4)
                    #endif
                    .padding(.horizontal, 8)
                    
            }
            
            TextEditor(text: $context)
                .padding(4)
                .focused($isFieldFocused)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFieldFocused = true
                    }
                }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(.body)
    }
}

struct CustomTextEditor_Previews: PreviewProvider {
    struct Preview: View {
        @State private var context: String = ""
        
        var body: some View {
            CustomTextEditor(
                placeholder: "Hello world",
                context: $context
            )
        }
    }
    static var previews: some View {
        Preview()
    }
}
