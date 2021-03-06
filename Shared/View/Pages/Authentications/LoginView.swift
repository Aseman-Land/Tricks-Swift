//
//  LoginView.swift
//  Tricks
//
//  Created by Armin on 2/18/22.
//

import SwiftUI

struct LoginView: View {
    
    @State var showSignupView: () -> Void
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    @StateObject var authModel = AuthViewModel()
    
    @FocusState private var focusedField: LoginField?
    
    @State var showRecoverView: Bool = false
    
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
        .sheet(isPresented: $showRecoverView) {
            RecoverPasswordView()
        }
        .task {
            authModel.profile = profile
        }
    }
    
    var content: some View {
        VStack {
            
            Spacer()
            
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
            
            // MARK: - Login button
            LoaderButton(loading: $authModel.loading) {
                Text("Login")
                    #if os(iOS)
                    .foregroundColor(Color("AccentTextColor"))
                    #endif
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: 200)
            } action: {
                Task.init {
                    await authModel.login()
                }
            }
            #if os(iOS)
            .buttonStyle(.borderedProminent)
            #elseif os(macOS)
            .buttonStyle(.bordered)
            #endif
            .controlSize(.large)
            .headerProminence(.increased)
            
            if authModel.errorMessage != "" {
                Text(authModel.errorMessage)
                    .foregroundColor(.red)
                    .shadow(radius: 2)
            }
            
            if !authModel.loading {
                Button(action: { showRecoverView = true }) {
                    Text("Recovery password")
                        .foregroundStyle(.secondary)
                        .font(.callout)
                }
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
                .padding(.top, 10)
            }
            
            Spacer()
            
            if !authModel.loading {
                Button(action: showSignupView) {
                    Text(signupAttributedString())
                }
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
                .padding(.bottom)
            }
        }
    }
    
    private func endEditing() {
        focusedField = nil
    }
    
    private func signupAttributedString() -> AttributedString {
        var string = AttributedString("Don't have an account? Sign up")
        string.foregroundColor = .secondary
        string.font = .callout
            
        if let range = string.range(of: "Sign up") {
            string[range].foregroundColor = .accentColor
            string[range].font = .callout.bold()
        }
        return string
    }
    
}

enum LoginField: Hashable {
    case username, password
}

struct LoginView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        ZStack {
            LoginView(showSignupView: {})
                .environmentObject(profile)
        }
    }
}
