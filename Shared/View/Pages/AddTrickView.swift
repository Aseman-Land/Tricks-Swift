//
//  AddTrickView.swift
//  Tricks
//
//  Created by Armin on 4/4/22.
//

import SwiftUI
import CodeEditor

struct AddTrickView: View {
    
    enum Syntax: String, CaseIterable, Identifiable {
        case cpp, swift, rust
        var id: Self { self }
    }

    @State private var selectedSyntax: CodeEditor.Language = .swift
    @State private var selectedTheme: CodeEditor.ThemeName = .agate
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var code: String = ""
    @State private var sending: Bool = false
    
    #if os(iOS)
    var toolsPlacement: ToolbarItemPlacement = .bottomBar
    #elseif os(macOS)
    var toolsPlacement: ToolbarItemPlacement = .automatic
    #endif
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            content
        }
        #elseif os (macOS)
        content
            .frame(minWidth: 650, minHeight: 400)
        #endif
    }
    
    var content: some View {
        CodeEditor(source: $code, language: selectedSyntax, theme: selectedTheme)
            .disableAutocorrection(true)
            .toolbar {
                ToolbarItemGroup(placement: toolsPlacement) {
                    HStack {
                        #if os(iOS)
                        Label("Syntax: ", systemImage: "chevron.left.forwardslash.chevron.right")
                            .foregroundColor(.accentColor)
                        #endif
                        Picker(selection: $selectedSyntax, label: Label("Syntax", systemImage: "chevron.left.forwardslash.chevron.right")) {
                            ForEach(CodeEditor.availableLanguages) { language in
                                Text(language.rawValue).tag(language)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelStyle(.titleAndIcon)
                    }
                    
                    #if os(macOS)
                    Divider()
                    #endif
                    
                    HStack {
                        #if os(iOS)
                        Label("Theme:", systemImage: "paintbrush")
                            .foregroundColor(.accentColor)
                        #endif
                        Picker(selection: $selectedTheme, label: Label("Theme", systemImage: "paintbrush")) {
                            ForEach(CodeEditor.availableThemes) { theme in
                                Text(theme.rawValue).tag(theme)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelStyle(.titleAndIcon)
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: closeView) {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    LoaderButton(loading: $sending) {
                        Text("Send")
                    } action: {
                        // TODO: Add Send function
                    }
                }
            }
    }
    
    private func closeView() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddTrickView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddTrickView()
    }
}
