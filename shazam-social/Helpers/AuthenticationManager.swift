//
//  AuthenticationManager.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/4/23.
//

import Foundation
import RealmSwift

/**
 Contains all the authentication functions.
 */
class AuthenticationManager: ObservableObject {
    static var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var authIsEnabled: Bool {
        isValidEmail(email) && password.count > 0
    }
    
    var enableButtons: Bool {
        !isLoading && authIsEnabled
    }
    
    func signup(name: String) {
        let client = app!.emailPasswordAuth
        
        isLoading = true
        errorMessage = nil
        
        client.registerUser(email: email, password: password) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Sign up error: \(error.localizedDescription)"
                    self?.isLoading = false
                } else {
                    self?.login()
                    AuthenticationManager.name = name
                }
            }
        }
    }
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        let credentials = Credentials.emailPassword(email: email, password: password)
        app!.login(credentials: credentials) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self?.errorMessage = "Login failed: \(error.localizedDescription)"
                case .success(_):
                    print("login success")
                }
                self?.isLoading = false
            }
        }
    }
    
    static func logout() {
        app!.currentUser?.logOut(completion: { error in
            if let error = error {
                print("error logout \(error)")
            }
        })
    }
}
