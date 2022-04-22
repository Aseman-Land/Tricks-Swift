//
//  SignupView.swift
//  Tricks
//
//  Created by Armin on 2/19/22.
//

import SwiftUI

struct SignupView: View {
    
    @State var showLoginView: () -> Void
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    @StateObject var authModel = AuthViewModel()
    
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
            
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    content
                        .frame(width: geometry.size.width)
                        .frame(minHeight: geometry.size.height)
                }
                .clipped()
            }
        }
        .task {
            authModel.profile = profile
        }
    }
    
    var content: some View {
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
                    SecureField("Repeat Password", text: $authModel.repeatPassword)
                        .frame(maxWidth: 300)
                        .privacySensitive(true)
                        .disabled(authModel.loading)
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
                    TextField("Email", text: $authModel.email)
                        .frame(maxWidth: 300)
                        .disabled(authModel.loading)
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
                    TextField("Your name", text: $authModel.fullname)
                        .frame(maxWidth: 300)
                        .disabled(authModel.loading)
                        .focused($focusedField, equals: .fullname)
                        .submitLabel(.done)
                        .onSubmit {
                            Task.init {
                                await authModel.signup()
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
            
            if !authModel.loading {
                Button(action: showLoginView) {
                    Text(loginAttributedString())
                }
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
                .padding(.bottom, 5)
            }
            
            // MARK: - Login button
            ZStack(alignment: .center) {
                LoaderButton(loading: $authModel.loading) {
                    Text("Register")
                        #if os(iOS)
                        .foregroundColor(Color("AccentTextColor"))
                        #endif
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: 200)
                } action: {
                    Task.init {
                        await authModel.signup()
                    }
                }
                #if os(iOS)
                .buttonStyle(.borderedProminent)
                #elseif os(macOS)
                .buttonStyle(.bordered)
                #endif
                .controlSize(.large)
                .headerProminence(.increased)
            }
        }
    }
    
    private func endEditing() {
        focusedField = nil
    }
    
    private func loginAttributedString() -> AttributedString {
        var string = AttributedString("Have an account? Login")
        string.foregroundColor = .secondary
        string.font = .callout
            
        if let range = string.range(of: "Login") {
            string[range].foregroundColor = .accentColor
            string[range].font = .callout.bold()
        }
        return string
    }
}

enum SignupField: Hashable {
    case username, password, repeatPassword, email, fullname
}

struct SignupView_Previews: PreviewProvider {
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        ZStack {
            SignupView(showLoginView: {})
                .environmentObject(profile)
        }
    }
}
