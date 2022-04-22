//
//  RecoverPasswordView.swift
//  Tricks
//
//  Created by Armin on 4/22/22.
//

import SwiftUI

struct RecoverPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var email: String = ""
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            ZStack(alignment: .center) {
                #if os(macOS)
                VisualEffectBlur(
                    material: .popover,
                    blendingMode: .behindWindow
                )
                    .edgesIgnoringSafeArea(.all)
                #endif

                GeometryReader { geometry in
                    ScrollView(.vertical) {
                        content
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.height)
                    }
                    .clipped()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: { closeView() }) {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .accentColor(Color("AccentColor"))
                }
            }
        }
        #elseif os(macOS)
        ZStack(alignment: .topLeading) {
            #if os(macOS)
            VisualEffectBlur(
                material: .popover,
                blendingMode: .behindWindow
            )
                .edgesIgnoringSafeArea(.all)
            #endif

            GeometryReader { geometry in
                ScrollView(.vertical) {
                    content
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                }
                .clipped()
            }
            
            Button(action: { closeView() }) {
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
            }
            .accentColor(Color("AccentColor"))
            .buttonStyle(.plain)
            .padding()
        }
        .frame(minWidth: 450, minHeight: 550)
        #endif
        
    }
    
    var content: some View {
        VStack {
            // MARK: - Promotion
            Image(systemName: "lock.rotation")
                .font(.system(size: 80))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.indigo)
                .padding()
            
            Text("Recover your Password")
                .font(.system(.title2, design: .monospaced))
                .multilineTextAlignment(.center)
            
            Label {
                // MARK: - Username Field
                TextField("Email", text: $email)
                    .frame(maxWidth: 300)
                    //.disabled(authModel.loading)
                    //.focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit {
                        Task.init {
                            //focusedField = .password
                        }
                    }
                    .padding()
            } icon: {
                Image(systemName: "envelope")
            }
            .disableAutocorrection(true)
            #if os(macOS)
            .textFieldStyle(.plain)
            #endif
            .padding()
            .background(
                .regularMaterial,
                in: RoundedRectangle(cornerRadius: 16.0)
            )
            .padding()
        }
        
    }
    
    func closeView() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct RecoverPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordView()
    }
}
