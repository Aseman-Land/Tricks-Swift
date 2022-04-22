//
//  SettingsView.swift
//  Tricks (iOS)
//
//  Created by Armin on 4/21/22.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showLogoutDialog: Bool = false
    
    @EnvironmentObject var profile: MyProfileViewModel
    
    var body: some View {
        NavigationView {
            content
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Settings" , displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { closeView() }) {
                            Image(systemName: "xmark.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .accentColor(Color("AccentColor"))
                    }
                }
                .confirmationDialog("Logout", isPresented: $showLogoutDialog) {
                    Button("Logout", role: .destructive) {
                        Task.init {
                            await profile.logout()
                            closeView()
                        }
                    }
                    Button("Cancel", role: .cancel){}
                } message: {
                    Text("Are you sure?")
                }
        }
    }
    
    var content: some View {
        List {
            Section {
                Button(action: { showLogoutDialog = true }) {
                    SettingsItemView(
                        icon: "rectangle.portrait.and.arrow.right.fill",
                        color: .red,
                        title: "Logout",
                        optionalIcon: "chevron.forward"
                    )
                }
            }
            
            Section {                
                NavigationLink(destination: AboutView()) {
                    SettingsItemView(
                        icon: "info.circle.fill",
                        color: .blue,
                        title: LocalizedStringKey("About")
                    )
                }
            }
        }
    }
    
    func closeView() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsItemView: View {
    var icon: String
    var color: Color
    var title: LocalizedStringKey
    var rotation: Double = 0
    var optionalIcon: String = ""
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Image(systemName: icon)
                    .rotationEffect(.degrees(rotation))
                    .font(.body)
                    .foregroundColor(color == .white ? .blue : .white)
            }
            .frame(width: 28, height: 28)
            .background(color)
            .cornerRadius(6)
            .shadow(radius: 0.5)
            
            Text(title)
                .foregroundColor(.primary)
            
            if optionalIcon != "" {
                Spacer()
                Image(systemName: optionalIcon)
                    .font(Font.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .opacity(0.5)
            }
        }
        .contentShape(Rectangle())
        /// Spacer not working with onTapGesture
        /// workaround: https://stackoverflow.com/questions/57191013/swiftui-cant-tap-in-spacer-of-hstack
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    @StateObject static var profile = MyProfileViewModel()
    
    static var previews: some View {
        SettingsView()
            .environmentObject(profile)
    }
}
