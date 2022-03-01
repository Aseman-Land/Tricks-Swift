//
//  LoginView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI

struct LoginView: View {
    
    @State var showSignupView: () -> Void
    
    @EnvironmentObject var profile: ProfileViewModel
    
    @StateObject var authModel = AuthViewModel()
    
    @FocusState private var focusedField: LoginField?
    
    var body: some View {
        ZStack(alignment: .center) {
            #if os(macOS)
            VisualEffectBlur(
                material: .popover,
                blendingMode: .behindWindow
            )
                .edgesIgnoringSafeArea(.all)
            #endif
            
            VStack {
                // MARK: - Promotion
                Text("Tricks")
                    .font(.system(.largeTitle, design: .monospaced))
                
                // MARK: - Fields
                VStack {
                    Label {
                        // MARK: - Username Field
                        TextField("Username", text: $authModel.username)
                            .frame(maxWidth: 300)
                            .disabled(authModel.loading)
                            .focused($focusedField, equals: .username)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .password
                            }
                            .padding()
                    } icon: {
                        Image(systemName: "person")
                    }
                    
                    Label {
                        // MARK: - Password Field
                        SecureField("Password", text: $authModel.password)
                            .frame(maxWidth: 300)
                            .privacySensitive(true)
                            .disabled(authModel.loading)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.done)
                            .padding()
                            .onSubmit {
                                Task.init {
                                    await authModel.login()
                                }
                            }
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
                
                if !authModel.loading {
                    Button(action: showSignupView) {
                        Text("Don't have an account? **Register**")
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 5)
                }
                
                // MARK: - Login button
                ZStack(alignment: .center) {
                    if !authModel.loading {
                        Button(action: {
                            Task.init {
                                await authModel.login()
                            }
                        }){
                            Text("Login")
                                #if os(iOS)
                                .foregroundColor(Color("AccentTextColor"))
                                #endif
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(maxWidth: 200)
                        }
                        #if os(iOS)
                        .buttonStyle(.borderedProminent)
                        #elseif os(macOS)
                        .buttonStyle(.bordered)
                        #endif
                        .controlSize(.large)
                        .headerProminence(.increased)
                        
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    }
                }
                
                if authModel.errorMessage != "" {
                    Text(authModel.errorMessage)
                        .foregroundColor(.red)
                        .shadow(radius: 2)
                }
            }
        }
        .task {
            authModel.profile = profile
        }
    }
    
    private func endEditing() {
        focusedField = nil
    }
}

enum LoginField: Hashable {
    case username, password
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LoginView(showSignupView: {})
        }
    }
}