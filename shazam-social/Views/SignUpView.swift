//
//  SignUpView.swift
//  shazam-social
//
//  Created by Brandon Wong on 2/4/23.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var authManager = AuthenticationManager()
    @State var error: Error?
    
    @State private var name = ""
    @State private var isLoggingIn = false
    @State private var scale = false
    
    var body: some View {
        VStack(alignment: .center) {
            if isLoggingIn {
                ProgressView()
            }
            
            if let error = error {
                Text("Error: \(error.localizedDescription)")
            }
            
            Group {
                // Used an AsyncImage instead of my custom cached version because it never scrolls out of view.
                AsyncImage(url: URL(string: "https://assets.stickpng.com/images/580b57fcd9996e24bc43c538.png")) { image in
                    image
                        .resizable()
                        .padding()
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale ? 0.95 : 1.05)
                        .task {
                            withAnimation(.easeInOut(duration: 1).repeatForever()) {
                                scale.toggle()
                            }
                        }
                } placeholder: {
                    ProgressView()
                }
                
                Text("Shazam Social").font(.largeTitle)
            }
            
            Group {
                TextField("Name", text: $name)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                
                TextField("Email", text: $authManager.email)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $authManager.password)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            }
            
            if authManager.isLoading {
                ProgressView()
            }
            
            if let error = authManager.errorMessage {
                Text(error)
                    .foregroundColor(.pink)
            }
            
            Group {
                Button("Sign Up") {
                    isLoggingIn = true
                    authManager.signup(name: name)
                    isLoggingIn = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(!authManager.authIsEnabled)
                
                Button("Already have an account? Log in!") {
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(authManager.isLoading)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
