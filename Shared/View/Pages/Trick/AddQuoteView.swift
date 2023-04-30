//
//  AddQuoteView.swift
//  Tricks
//
//  Created by Armin on 3/4/22.
//

import SwiftUI

struct AddQuoteView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var addQuoteMode: AddQuoteViewModel
    @State var trickID: Int
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            content
                .navigationTitle("Quote")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(action: closeView) {
                            Text("Cancel")
                        }
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        sendButton
                    }
                }
        }
        #else
        VStack {
            content
            
            HStack {
                Spacer()
                
                Button(action: closeView) {
                    Text("Cancel")
                }
                
                sendButton
            }
            .padding()
        }
        #endif
    }
    
    var content: some View {
        CustomTextEditor(
            placeholder: "Write your quote",
            context: $addQuoteMode.quote
        )
        .padding()
        .alert(isPresented: $addQuoteMode.showErrorMessage) {
            Alert(
                title: Text("Failed to send your quote"),
                message: Text(addQuoteMode.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    var sendButton: some View {
        LoaderButton(loading: $addQuoteMode.loading) {
            Text("Send")
        } action: {
            Task.init {
                await addQuoteMode.send(trickID: trickID)
            }
        }
    }
    
    private func closeView() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddQuoteView_Previews: PreviewProvider {
    
    static private var trick = Trick.placeHolder()
    @StateObject static var addQuoteModel = AddQuoteViewModel()
    
    static var previews: some View {
        AddQuoteView(trickID: trick.id)
            .environmentObject(addQuoteModel)
    }
}
