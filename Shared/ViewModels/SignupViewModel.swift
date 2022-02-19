//
//  SignupViewModel.swift
//  Tricks
//
//  Created by Armin on 2/19/22.
//

import Foundation

enum SignupField: Hashable {
    case username, password, repeatPassword, email, fullname
}

class SignupViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    @Published var email: String = ""
    @Published var fullname: String = ""
    
    @Published var loading: Bool = false
    
    func signup() async {
        loading = true
    }
}
