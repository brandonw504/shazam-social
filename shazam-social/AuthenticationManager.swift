//
//  AuthenticationManager.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/2/23.
//

import Foundation
import RealmSwift
import AuthenticationServices

class AuthenticationManager: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func anonymouslyLogin() {
        isLoading = true
        errorMessage = nil
        
        app!.login(credentials: .anonymous) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(_):
                        print("Success: Anonymously logged in")
                    case .failure(_):
                        self?.errorMessage = "Login Failed"
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
