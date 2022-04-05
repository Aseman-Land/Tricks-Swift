//
//  AddTrickView.swift
//  Tricks
//
//  Created by Armin on 4/4/22.
//

import SwiftUI

struct AddTrickView: View {
    
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
            .frame(minWidth: 550, minHeight: 400)
        #endif
    }
    
    var content: some View {
        ScrollView {
            TextEditor(text: $code)
                .disableAutocorrection(true)
                .frame(minHeight: 450)
        }
        .toolbar {
            ToolbarItemGroup(placement: toolsPlacement) {
                Menu {
                    Button("C++") {}
                    Button("Swift") {}
                } label: {
                    Label("Syntax", systemImage: "chevron.left.forwardslash.chevron.right")
                        .labelStyle(.titleAndIcon)
                }
                
                Menu {
                    Button("Dracula") {}
                    Button("Github") {}
                } label: {
                    Label("Theme", systemImage: "paintbrush")
                        .labelStyle(.titleAndIcon)
                }
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button(action: closeView) {
                    Text("Cancel")
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                LoaderButton(title: "Send", loading: $sending) {
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
