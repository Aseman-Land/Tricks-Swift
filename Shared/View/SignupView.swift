//
//  SignupView.swift
//  Tricks
//
//  Created by Armin on 2/19/22.
//

import SwiftUI

struct SignupView: View {
    
    @State var showLoginView: () -> Void
    
    @StateObject var signupModel = SignupViewModel()
    @FocusState private var focusedField: SignupField?
    
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
                Text("Join Tricks Community!")
                    .font(.system(.largeTitle, design: .monospaced))
                    .dynamicTypeSize(.xSmall ... .large)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding()
                
                // MARK: - Fields
                VStack {
                    Label {
                        // MARK: - Username Field
                        TextField("Username", text: $signupModel.username)
                            .frame(maxWidth: 300)
                            .disabled(signupModel.loading)
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
                        SecureField("Password", text: $signupModel.password)
                            .frame(maxWidth: 300)
                            .privacySensitive(true)
                            .disabled(signupModel.loading)
                            .focused($focusedField, equals: .password)
                            .submitLabel(.next)
                            .padding()
                            .onSubmit {
                                focusedField = .repeatPassword
                            }
                    } icon: {
                        Image(systemName: "lock")
                    }
                    
                    Label {
                        // MARK: - Password Field
                        SecureField("Repeat Password", text: $signupModel.repeatPassword)
                            .frame(maxWidth: 300)
                            .privacySensitive(true)
                            .disabled(signupModel.loading)
                            .focused($focusedField, equals: .repeatPassword)
                            .submitLabel(.next)
                            .padding()
                            .onSubmit {
                                focusedField = .email
                            }
                    } icon: {
                        Image(systemName: "lock")
                    }
                    
                    Label {
                        // MARK: - Username Field
                        TextField("Email", text: $signupModel.email)
                            .frame(maxWidth: 300)
                            .disabled(signupModel.loading)
                            .focused($focusedField, equals: .email)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedField = .fullname
                            }
                            .padding()
                    } icon: {
                        Image(systemName: "envelope")
                    }
                    
                    Label {
                        // MARK: - Username Field
                        TextField("Your name", text: $signupModel.fullname)
                            .frame(maxWidth: 300)
                            .disabled(signupModel.loading)
                            .focused($focusedField, equals: .fullname)
                            .submitLabel(.done)
                            .onSubmit {
                                Task.init {
                                    await signupModel.signup()
                                }
                            }
                            .padding()
                    } icon: {
                        Image(systemName: "signature")
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
                
                if !signupModel.loading {
                    Button(action: showLoginView) {
                        Text("Have an account? **Login**")
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 5)
                }
                
                // MARK: - Login button
                ZStack(alignment: .center) {
                    if !signupModel.loading {
                        Button(action: {
                            Task.init {
                                await signupModel.signup()
                            }
                        }){
                            Text("Register")
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
            }
        }
    }
    
    private func endEditing() {
        focusedField = nil
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SignupView(showLoginView: {})
        }
    }
}
