//
//  RecoverPasswordView.swift
//  Tricks
//
//  Created by Armin on 4/22/22.
//

import SwiftUI

struct RecoverPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var model : RecoverPaswordViewModel = RecoverPaswordViewModel()
    
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
            VisualEffectBlur(
                material: .popover,
                blendingMode: .behindWindow
            )
                .edgesIgnoringSafeArea(.all)

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
            switch model.status {
            case .enterEmail:
                // MARK: - Promotion
                Image(systemName: "lock.rotation")
                    .font(.system(size: 80))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.indigo)
                    .padding()
                
                Text("Recover your Password")
                    .font(.system(.title2, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Label {
                    // MARK: - Username Field
                    TextField("Email", text: $model.email)
                        .frame(maxWidth: 300)
                        .disabled(model.loading)
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
                
                LoaderButton(loading: $model.loading) {
                    Text("Send")
                        #if os(iOS)
                        .foregroundColor(Color("AccentTextColor"))
                        #endif
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: 200)
                } action: {
                    Task.init {
                        await model.sendCode()
                    }
                }
                #if os(iOS)
                .buttonStyle(.borderedProminent)
                #elseif os(macOS)
                .buttonStyle(.bordered)
                #endif
                .controlSize(.large)
                .headerProminence(.increased)
                
                if model.errorMessage != "" {
                    Text(model.errorMessage)
                        .foregroundColor(.red)
                        .shadow(radius: 2)
                }
            case .enterCode:
                // MARK: - Promotion
                Image(systemName: "mail.and.text.magnifyingglass")
                    .font(.system(size: 80))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.indigo)
                    .padding()
                
                Text("Enter the code we have sent to your email and type your new password")
                    .font(.system(.title2, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack {
                    Label {
                        // MARK: - Username Field
                        TextField("Code", text: $model.code)
                            .frame(maxWidth: 300)
                            .disabled(model.loading)
                            .padding()
                    } icon: {
                        Image(systemName: "number")
                    }
                    
                    Label {
                        // MARK: - Password Field
                        SecureField("New Password", text: $model.newPassword)
                            .frame(maxWidth: 300)
                            .privacySensitive(true)
                            .disabled(model.loading)
                            .padding()
                    } icon: {
                        Image(systemName: "lock")
                    }
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
                
                LoaderButton(loading: $model.loading) {
                    Text("Send")
                        #if os(iOS)
                        .foregroundColor(Color("AccentTextColor"))
                        #endif
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: 200)
                } action: {
                    Task.init {
                        await model.recoverPassword {
                            closeView()
                        }
                    }
                }
                #if os(iOS)
                .buttonStyle(.borderedProminent)
                #elseif os(macOS)
                .buttonStyle(.bordered)
                #endif
                .controlSize(.large)
                .headerProminence(.increased)
                
                if model.errorMessage != "" {
                    Text(model.errorMessage)
                        .foregroundColor(.red)
                        .shadow(radius: 2)
                }
            case .success:
                VStack {
                    // MARK: - Promotion
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 80))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.green)
                        .padding()
                    
                    Text("Success! Now login with your new password")
                        .font(.system(.title2, design: .monospaced))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
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
