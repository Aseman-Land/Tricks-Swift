//
//  LoginViewModel.swift
//  Tricks
//
//  Created by Armin on 2/19/22.
//

import Foundation

enum LoginField: Hashable {
    case username, password
}

class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    
    @Published var loading: Bool = false
    
    func login() async {
        loading = true
    }
}
